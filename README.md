# Verilog HDL 语法指南（verilog-guide）

面向数字 IC 设计工程师的 Verilog HDL（IEEE 1364-2005）语法指南文档站。

**三大设计约束：**

1. **正确性** — `examples/` 下所有代码示例是唯一真源，经 Icarus Verilog 12 编译 + `vvp` 仿真 + `PASS` 断言验证，任一失败则全站构建失败
2. **离线** — 依赖安装后构建/维护/浏览全程离线；无 CDN、无 Google Fonts、搜索索引（lunr.js）随站打包
3. **轻量化** — 4 个 Python 顶层依赖、构建产物 ~3 MB、校验 < 1 分钟

## 安装（仅首次需要网络）

```bash
/d/python/python.exe -m venv .venv
.venv/Scripts/python.exe -m pip install -r requirements.txt        # 仅此步需要网络
.venv/Scripts/python.exe -m pip download -r requirements.txt -d wheels/   # 离线重装快照
```

之后全部操作离线。若需在新机器离线重装：`pip install --no-index --find-links wheels/ -r requirements.txt`。

## 日常使用（全程离线）

```bash
.venv/Scripts/python.exe tools/verify_examples.py   # 1. 校验全部示例（编译+仿真+一致性）
.venv/Scripts/python.exe tools/check.py             # 2. 一键总检查（校验+严格构建+外链审计）
.venv/Scripts/python.exe tools/serve.py --open      # 3. 离线浏览构建产物
```

> ⚠️ **禁止双击 `site/index.html` 浏览**：`file://` 协议下搜索被浏览器 CORS 拦截。必须用 `serve.py`（或 `python -m http.server -d site`）。

## 发布（GitHub Pages）

推送 `main` 即自动构建发布（`.github/workflows/pages.yml`），线上地址：

https://ahoyhakunamatata.github.io/verilog-guide/

- 首次发布：仓库 Settings → Pages → Source 选 **GitHub Actions**，然后到 Actions 页重跑一次失败的 workflow（或再推一次提交）
- 发布前本地把关：`tools/check.py` 全绿再推送（CI 只构建，示例验证依赖本机 iverilog 工具链）

## 写作约定（新增/修改示例必读）

### 示例源真机制

- 示例以 `examples/NN-章节名/` 下的 `.v` 文件为**唯一真源**；文档用 snippet 嵌入：

  ````markdown
  ```verilog
  --8<-- "examples/07-combinational/mux4_case.v"
  ```
  ````

- **配对规则**：每个设计文件 `topic.v` 必须有同目录同名 `topic_tb.v`，否则校验失败。无配对设计文件的 TB 视为自包含演示（13/14/15 章使用）。
- **一个主题 = 一对文件**：一个主题需要多个模块时写进同一个 `.v` 文件（一个文件允许多个 `module`）。
- **TB 自检约定**：每个 TB 必须含 `$display("PASS");` 与 `$finish;`；失败用 `$display("FAIL ...");` 或 `$fatal`。仿真断言 = 退出码 0 + 输出含 `PASS` 行 + 无 `FAIL` 行 + 30s 超时。
- **`$display` 文本一律 ASCII**（Windows 控制台 cp936 限制）；中文只写在注释里。`.v` 与 `.md` 文件统一 UTF-8。
- **碎片约束**：凡展示可运行代码必须是完整可编译单元进 `examples/`；纯语法片段（如 `4'b1010`、`assign y = sel ? a : b;`）只用行内代码，不机验。
- **双向一致性**：文档引用的 snippet 必须存在；`examples/` 下每个 `.v` 必须被文档引用至少一次（防"死示例"）。两处由 `verify_examples.py` 强制检查。
- **不粘贴仿真输出文本块**（防输出漂移），正确性由验证报告背书。

### 标注图例

| 标注 | 含义 |
|---|---|
| `!!! success` | **可综合**：可用于 RTL 设计 |
| `!!! danger` | **不可综合，仅仿真** |
| `!!! warning` | **慎用**：依赖工具或易引入隐患 |
| `!!! tip` | **推荐写法** |

### 文档模板

```markdown
### 示例 07-1：四选一多路选择器

=== "推荐：case 写法"

    ```verilog
    --8<-- "examples/07-combinational/mux4_case.v"
    ```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/07-combinational/mux4_case_tb.v"
    ```
```

- 对比场景（推荐/不推荐、同步/异步复位等）用 `=== "tab"` 标签页
- 测试台用 `??? note` 折叠展示
- fence 语言一律写 `verilog`（禁止 `systemverilog`，防混入 SV 语法）
- 编译标准：一律 `iverilog -g2005`（脚本已写死）

### 新增章节流程

1. 写 `examples/NN-*/topic.v` + `topic_tb.v` → `verify_examples.py` 全绿
2. 写 `docs/NN-*.md` 并嵌入 snippet
3. **同步更新 `mkdocs.yml` 的 `nav`**（`strict: true` 下 nav 缺失或多余都会构建失败）
4. `check.py` → `serve.py` 浏览确认排版

## 目录结构

```
verilog-guide/
├── mkdocs.yml           # 站点配置（离线关键项：font: false、本地 search、strict）
├── requirements.txt     # 固定版本（ASCII only，pip 在 cp936 下读取）
├── docs/                # 文档源（Markdown，UTF-8，01~18 章）
├── examples/            # 示例真源（Verilog，目录编号与 docs 章对应）
├── tools/               # verify_examples.py / check.py / serve.py（纯标准库）
├── build/  site/        # 产物（gitignore，可随时删除重建）
├── wheels/              # 离线重装依赖快照（gitignore）
└── .venv/               # 项目虚拟环境（gitignore）
```
