# 07 组合逻辑典型电路与推荐写法

!!! success "本章全部示例均可综合"
    本章所有示例均为可综合的组合逻辑电路，并经 Icarus Verilog 编译 + 仿真验证。

组合逻辑的输出只取决于当前输入（无记忆）。RTL 中描述组合逻辑只有两种途径：`assign` 连续赋值，或 `always @(*)` 过程块。

## 7.1 译码器

!!! tip "推荐写法"
    用 `case` 逐项列出译码关系，意图直接；注意写全所有项（或加 `default`）。

### 示例 07-1：3-8 译码器

```verilog
--8<-- "examples/07-combinational/decoder38.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/07-combinational/decoder38_tb.v"
    ```

## 7.2 优先编码器

与普通编码器不同，优先编码器的**多个输入同时有效时高位优先**。优先级语义天然对应 if-else 链。

### 示例 07-2：4-2 优先编码器

```verilog
--8<-- "examples/07-combinational/priority_encoder.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/07-combinational/priority_encoder_tb.v"
    ```

## 7.3 多路选择器

!!! tip "推荐写法"
    多路选择器优先用 `case` 语句描述：意图清晰、综合工具能可靠识别为并行 MUX 结构。

=== "推荐：case 写法"

    ```verilog
    --8<-- "examples/07-combinational/mux4_case.v"
    ```

=== "等价：条件操作符链"

    ```verilog
    --8<-- "examples/07-combinational/mux4_ternary.v"
    ```

两种写法语义完全等价。区别在于：`case` 写法将"选择"意图表达得更直接；条件操作符链更适合连续赋值（`assign`）场景。

??? note "配套自检测试台"

    === "mux4_case"

        ```verilog
        --8<-- "examples/07-combinational/mux4_case_tb.v"
        ```

    === "mux4_ternary"

        ```verilog
        --8<-- "examples/07-combinational/mux4_ternary_tb.v"
        ```

## 7.4 加法器

行为级直接写 `assign sum = a + b;`（综合工具会优化为最优结构，**推荐**）；结构级行波进位用于教学与结构对比。

### 示例 07-3：4 位行波进位加法器（结构描述）

```verilog
--8<-- "examples/07-combinational/rca4.v"
```

??? note "配套自检测试台（穷举 256 组合）"

    ```verilog
    --8<-- "examples/07-combinational/rca4_tb.v"
    ```

!!! tip "工程建议"
    实际工程中加法直接用 `+` 描述，进位保留靠**位宽上下文**（见 3.5 节）：LHS 声明为 `[N:0]` 即可。

## 7.5 比较器

直接用关系操作符即可，综合工具会优化。

### 示例 07-4：4 位比较器

```verilog
--8<-- "examples/07-combinational/comparator4.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/07-combinational/comparator4_tb.v"
    ```

## 7.6 三态总线

!!! warning "内部三态慎用"
    芯片内部的模块间总线**不要**用三态（测试与可测性差，多数工艺不支持内部三态缓冲），优先用 MUX 数据通路；三态用于芯片顶层 IO/双向总线。

### 示例 07-5：inout 三态总线

```verilog
--8<-- "examples/07-combinational/tristate_bus.v"
```

??? note "配套自检测试台（多主设备共享总线）"

    ```verilog
    --8<-- "examples/07-combinational/tristate_bus_tb.v"
    ```

    TB 验证了四种情形：A 独占驱动、B 独占驱动、双高阻（z）、**双驱动冲突（x）**——冲突是总线的真实故障模式。

## 7.7 意外锁存器：产生与规避

!!! danger "最常见的新手事故"
    `always @(*)` 中条件不完整（if 缺 else、case 缺 default/漏项）时，输出在某些输入组合下"保持原值"——综合工具把它实现为**锁存器**（有记忆的组合逻辑）。这通常不是设计意图，且锁存器对时序分析与 DFT 都不友好。

**规避法则：** 组合逻辑 `always @(*)` 块内，**所有输出在所有分支下都必须有赋值**。

### 示例 07-6：锁存推断演示

```verilog
--8<-- "examples/07-combinational/latch_accidental.v"
```

??? note "配套自检测试台（实证锁存的"记忆"）"

    ```verilog
    --8<-- "examples/07-combinational/latch_accidental_tb.v"
    ```

    TB 演示：`en=0` 时 `q_latched` 保持旧值（锁存），而条件完整的 `q_gated` 输出 0（纯组合）。

## 7.8 组合逻辑描述模板

`always @(*)` 与 `assign` 在组合逻辑上等价，按复杂度选择：

- 简单表达式（单行）→ `assign`
- 多分支选择（case/if 链）→ `always @(*)`

### 示例 07-7：两种模板等价性

```verilog
--8<-- "examples/07-combinational/comb_template.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/07-combinational/comb_template_tb.v"
    ```
