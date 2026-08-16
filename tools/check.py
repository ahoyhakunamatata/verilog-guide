#!/usr/bin/env python3
"""一键总检查（替代 make）：校验示例 + 严格构建 + 外链审计。

流程：
1. verify_examples.py —— 全部示例编译+仿真+一致性检查
2. mkdocs build --strict —— 任何警告（失效 snippet、断链）即失败
3. 外链审计 —— site/ 内出现 http(s):// 引用即 FAIL（硬性禁 CDN）
4. 搜索索引检查 —— site/search/search_index.json 必须存在（本地 lunr.js）

用法：
    python tools/check.py [--skip-verify] [--skip-build]
"""
import argparse
import re
import subprocess
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
SITE_DIR = PROJECT_ROOT / "site"
EXTERNAL_RE = re.compile(r"""(?:src|href)\s*=\s*["']https?://""", re.IGNORECASE)


def run(cmd, cwd=PROJECT_ROOT, timeout=600):
    print(">> " + " ".join(str(c) for c in cmd))
    return subprocess.run([str(c) for c in cmd], cwd=str(cwd), timeout=timeout)


def audit_site():
    errors = []
    html_files = sorted(SITE_DIR.rglob("*.html"))
    for h in html_files:
        text = h.read_text(encoding="utf-8", errors="replace")
        for m in EXTERNAL_RE.finditer(text):
            errors.append("%s: %s" % (h.relative_to(PROJECT_ROOT), m.group(0)))
    if not (SITE_DIR / "search" / "search_index.json").exists():
        errors.append("site/search/search_index.json missing (local search broken)")
    return errors


def main():
    ap = argparse.ArgumentParser(description="One-shot full check")
    ap.add_argument("--skip-verify", action="store_true")
    ap.add_argument("--skip-build", action="store_true")
    ap.add_argument("--skip-audit", action="store_true")
    args = ap.parse_args()

    python = sys.executable
    failures = []

    if not args.skip_verify:
        rc = run([python, PROJECT_ROOT / "tools" / "verify_examples.py"]).returncode
        if rc != 0:
            failures.append("verify_examples.py exited %d" % rc)

    if not args.skip_build:
        rc = run([python, "-m", "mkdocs", "build", "--strict"]).returncode
        if rc != 0:
            failures.append("mkdocs build --strict exited %d" % rc)

    if not args.skip_audit and (SITE_DIR / "index.html").exists():
        errors = audit_site()
        if errors:
            failures.append("external-link audit: %d hit(s)" % len(errors))
            for e in errors:
                print("  - " + e)

    print("-" * 64)
    if failures:
        print("CHECK FAILED:")
        for f in failures:
            print("  - " + f)
        return 1
    print("ALL CHECKS PASSED")
    return 0


if __name__ == "__main__":
    sys.exit(main())
