#!/usr/bin/env python3
"""Verilog 示例校验引擎（纯标准库，无第三方依赖）。

职责：
1. 发现 examples/**/*.v，按 *_tb.v 后缀分类配对；
2. 静态约定检查：每个 testbench 必须含 $display("PASS") 与 $finish；
3. 编译 + 仿真：iverilog -g2005 编译，vvp 运行并断言 PASS/无 FAIL/30s 超时；
4. 双向一致性检查：文档引用的 snippet 必须存在，examples 中每个 .v 必须被文档引用；
5. 输出 ASCII 汇总报告，退出码 0=全绿 1=有失败 2=用法错误。

用法：
    python tools/verify_examples.py [--iverilog PATH] [--vvp PATH] [--jobs N]
                                    [--skip-consistency] [--verbose]
"""
import argparse
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_IVERILOG = Path("D:/iverilog/bin/iverilog.exe")
DEFAULT_VVP = Path("D:/iverilog/bin/vvp.exe")

SNIPPET_RE = re.compile(r'--8<--\s+"([^"]+)"')
SNIPPET_SUFFIXES = {".v", ".vh", ".h", ".hex"}   # 文档可嵌入的示例文件类型
PASS_RE = re.compile(r"^\s*PASS\s*$", re.MULTILINE)
FAIL_RE = re.compile(r"^\s*FAIL\b", re.MULTILINE)
TIMEOUT_S = 30


def find_iverilog_version(iverilog: Path) -> str:
    """读取 iverilog 版本首行（ASCII），失败时返回占位符。"""
    try:
        out = subprocess.run(
            [str(iverilog), "-V"], capture_output=True, timeout=10
        ).stdout.decode("ascii", errors="replace")
        return out.splitlines()[0] if out else "unknown"
    except Exception:
        return "unknown"


def discover(examples_dir: Path):
    """返回 (设计文件列表, 测试台列表)。设计文件按是否有同名 _tb.v 配对校验。"""
    files = sorted(p for p in examples_dir.rglob("*.v") if p.is_file())
    tbs = [p for p in files if p.stem.endswith("_tb")]
    designs = [p for p in files if not p.stem.endswith("_tb")]

    pairs = []          # (design, tb) 配对单元
    self_contained = []  # 无配对设计文件的自包含 TB
    for d in designs:
        tb = d.with_name(d.stem + "_tb.v")
        if tb in tbs:
            pairs.append((d, tb))
        else:
            pairs.append((d, None))  # None 表示缺 TB，校验时报 FAIL
    paired_stems = {tb.stem[:-3] for tb in tbs}
    for tb in tbs:
        design = tb.with_name(tb.stem[:-3] + ".v")
        if design not in designs:
            self_contained.append(tb)
    return pairs, self_contained


def static_check_tb(tb: Path):
    """静态约定检查，返回错误消息列表（空=通过）。"""
    src = tb.read_text(encoding="utf-8", errors="replace")
    errors = []
    if '$display("PASS")' not in src:
        errors.append('missing $display("PASS") marker')
    if "$finish" not in src:
        errors.append("missing $finish")
    return errors


def run_unit(chapter: str, topic: str, design, tb, iverilog, vvp, build_dir: Path):
    """编译+仿真一个校验单元。design 为 None 时 tb 自包含。返回结果字典。"""
    build_dir.mkdir(parents=True, exist_ok=True)
    vvp_out = build_dir / f"{topic}.vvp"
    cwd = design.parent if design is not None else tb.parent

    cmd = [str(iverilog), "-g2005", "-Wall", "-o", str(vvp_out)]
    if design is not None:
        cmd.append(str(design))
    cmd.append(str(tb))

    result = {"unit": f"{chapter}/{topic}", "errors": []}
    t0 = None
    import time
    t0 = time.perf_counter()
    try:
        comp = subprocess.run(
            cmd, cwd=str(cwd), capture_output=True, timeout=TIMEOUT_S
        )
    except subprocess.TimeoutExpired:
        result["errors"].append("compile timeout")
        return result
    result["compile_s"] = time.perf_counter() - t0
    if comp.returncode != 0:
        err = comp.stderr.decode("utf-8", errors="replace")
        lines = [l for l in err.splitlines() if l.strip()][:20]
        result["errors"].append("compile failed:\n" + "\n".join(lines))
        return result

    t0 = time.perf_counter()
    try:
        sim = subprocess.run(
            [str(vvp), str(vvp_out)], cwd=str(cwd), capture_output=True,
            timeout=TIMEOUT_S
        )
    except subprocess.TimeoutExpired:
        result["errors"].append("sim timeout (>%ds, missing $finish?)" % TIMEOUT_S)
        return result
    result["sim_s"] = time.perf_counter() - t0
    out = sim.stdout.decode("utf-8", errors="replace")
    if sim.returncode != 0:
        result["errors"].append("sim exit code %d" % sim.returncode)
    if not PASS_RE.search(out):
        result["errors"].append("no PASS line in output")
    if FAIL_RE.search(out):
        result["errors"].append("FAIL line in output")
    return result


def consistency_check(examples_dir: Path, docs_dir: Path):
    """双向一致性：文档引用必须存在；examples 每个 .v 必须被引用。"""
    refs = []
    for md in docs_dir.rglob("*.md"):
        for m in SNIPPET_RE.finditer(md.read_text(encoding="utf-8", errors="replace")):
            refs.append((md, m.group(1)))
    errors = []
    referenced = set()
    for md, ref in refs:
        target = (PROJECT_ROOT / ref).resolve()
        if not target.exists():
            errors.append(f"{md.relative_to(PROJECT_ROOT)}: missing snippet {ref}")
        elif target.suffix not in SNIPPET_SUFFIXES:
            errors.append(f"{md.relative_to(PROJECT_ROOT)}: unsupported snippet type: {ref}")
        else:
            referenced.add(target)
    for v in examples_dir.rglob("*.v"):
        if v.resolve() not in referenced:
            errors.append(f"unreferenced example: {v.relative_to(PROJECT_ROOT)}")
    return errors


def main():
    ap = argparse.ArgumentParser(description="Verilog example verification engine")
    ap.add_argument("--iverilog", default=str(DEFAULT_IVERILOG))
    ap.add_argument("--vvp", default=str(DEFAULT_VVP))
    ap.add_argument("--examples", default=str(PROJECT_ROOT / "examples"))
    ap.add_argument("--docs", default=str(PROJECT_ROOT / "docs"))
    ap.add_argument("--build", default=str(PROJECT_ROOT / "build"))
    ap.add_argument("--jobs", type=int, default=1)
    ap.add_argument("--skip-consistency", action="store_true")
    ap.add_argument("--verbose", action="store_true")
    args = ap.parse_args()

    iverilog, vvp = Path(args.iverilog), Path(args.vvp)
    examples_dir = Path(args.examples)
    docs_dir = Path(args.docs)
    build_root = Path(args.build)

    if not iverilog.exists():
        print("ERROR: iverilog not found: %s" % iverilog)
        return 2
    if not vvp.exists():
        print("ERROR: vvp not found: %s" % vvp)
        return 2

    version = find_iverilog_version(iverilog)
    print("verify_examples.py | %s | -g2005" % version)

    pairs, self_contained = discover(examples_dir)

    # 组装校验单元：(chapter, topic, design, tb)
    units = []
    for d, tb in pairs:
        chapter = d.parent.name
        units.append((chapter, d.stem, d, tb))
    for tb in self_contained:
        units.append((tb.parent.name, tb.stem, None, tb))

    # 静态约定检查
    static_fail = []
    for chapter, topic, design, tb in units:
        if tb is None:
            static_fail.append((chapter, topic, "design missing paired _tb.v"))
            continue
        for e in static_check_tb(tb):
            static_fail.append((chapter, topic, e))

    # 编译+仿真
    def work(u):
        chapter, topic, design, tb = u
        if tb is None:
            return {"unit": f"{chapter}/{topic}", "errors": ["design missing paired _tb.v"]}
        if (chapter, topic) in {(f[0], f[1]) for f in static_fail}:
            return {"unit": f"{chapter}/{topic}", "errors": ["static check failed"]}
        build_dir = build_root / chapter
        return run_unit(chapter, topic, design, tb, iverilog, vvp, build_dir)

    results = []
    if args.jobs > 1:
        with ThreadPoolExecutor(max_workers=args.jobs) as ex:
            futs = [ex.submit(work, u) for u in units]
            for f in as_completed(futs):
                results.append(f.result())
    else:
        results = [work(u) for u in units]

    # 报告
    n_pass = n_fail = 0
    for r in sorted(results, key=lambda r: r["unit"]):
        if r["errors"]:
            n_fail += 1
            print("[FAIL] %-40s %s" % (r["unit"], r["errors"][0]))
            for e in r["errors"][1:]:
                print("       " + e.replace("\n", "\n       "))
        else:
            n_pass += 1
            print("[PASS] %-40s compile %.2fs sim %.2fs"
                  % (r["unit"], r.get("compile_s", 0), r.get("sim_s", 0)))

    print("-" * 64)
    print("Total %d  Passed %d  Failed %d" % (len(units), n_pass, n_fail))

    cons_errors = [] if args.skip_consistency else consistency_check(examples_dir, docs_dir)
    if cons_errors:
        print("Consistency: %d problem(s)" % len(cons_errors))
        for e in cons_errors:
            print("  - " + e)
    else:
        print("Consistency: %s" % ("skipped" if args.skip_consistency else "OK"))

    if n_fail == 0 and not cons_errors:
        print("ALL EXAMPLES VERIFIED")
        return 0
    return 1


if __name__ == "__main__":
    sys.exit(main())
