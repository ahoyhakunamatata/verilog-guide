# 12 编译指令与宏

编译指令以反引号开头（`` `define ``、`` `timescale `` 等），在**编译期**处理，不是语言关键字、不产生硬件。

## 12.1 指令总览

| 指令 | 作用 | 工程定位 |
|---|---|---|
| `` `define `` / `` `undef `` | 定义/取消文本宏（支持带参宏） | ✅ 常量、代码片段复用 |
| `` `ifdef ``/`` `ifndef ``/`` `elsif ``/`` `else ``/`` `endif `` | 条件编译 | ✅ 仿真/综合隔离、功能开关 |
| `` `include `` | 文件内联 | ✅ 共享头文件 |
| `` `timescale `` | 时间单位/精度 | ✅ TB 必写；多模块混合见 12.5 |
| `` `default_nettype `` | 隐式网络类型（设 none 防漏声明） | ✅ 建议 `none |
| `` `resetall `` | 恢复全部指令默认值 | ⚠️ 极少使用 |
| `` `celldefine ``/`` `endcelldefine `` | 单元库标注 | ⚠️ 库建模用 |
| `` `line `` | 行号/文件重映射（生成的代码用） | ⚠️ 工具生成代码用 |

## 12.2 `define 宏

- 文本替换：宏名展开时机是编译预处理
- 带参宏的**参数与整体都要加括号**，防止展开后结合优先级错乱
- 宏是全局的（跨文件可见，直到 `undef），与作用域无关——命名前缀防冲突

### 示例 12-1：常量宏与带参宏

```verilog
--8<-- "examples/12-directives/define_macro.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/12-directives/define_macro_tb.v"
    ```

## 12.3 条件编译

典型用途：

1. **仿真/综合隔离**：`` `ifdef SIMULATION `` 包住 `$display` 等仿真专用语句，综合时不编译
2. **功能开关**：同一 RTL 按配置编译出不同功能版本
3. **版本保护**：头文件防重复包含

### 示例 12-2：功能开关

```verilog
--8<-- "examples/12-directives/ifdef_guard.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/12-directives/ifdef_guard_tb.v"
    ```

## 12.4 `include 头文件

共享定义集中到 `.h`/`.vh` 文件，多个模块 `` `include `` 同一份——单点维护。

### 示例 12-3：共享定义头文件

=== "defs.h（共享头文件）"

    ```verilog
    --8<-- "examples/12-directives/defs.h"
    ```

=== "include_demo.v（使用者）"

    ```verilog
    --8<-- "examples/12-directives/include_demo.v"
    ```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/12-directives/include_demo_tb.v"
    ```

!!! tip "文件组织"
    头文件建议扩展名 `.vh`（Verilog header）并放在统一目录；`` `include `` 路径相对当前编译目录解析（或用编译器 `-I` 指定搜索路径）。

## 12.5 `timescale 与多模块冲突

```verilog
`timescale 1ns/1ps   // 单位 1ns，精度 1ps
```

- 单位决定延时书写（`#10` = 10ns）与 `$time` 的步进；精度决定仿真的最小分辨率与小数延时能力
- **多文件工程中不同 `timescale 会取最小精度统一**，未写 `timescale 的模块按工具默认——因此本指南所有 TB 都显式写 `` `timescale 1ns/1ps ``

### 示例 12-4：小数延时（依赖精度）

```verilog
--8<-- "examples/12-directives/timescale_demo.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/12-directives/timescale_demo_tb.v"
    ```
