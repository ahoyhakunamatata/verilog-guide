# 04 模块与层次结构

模块（module）是 Verilog 设计的基本单元，对应硬件中的一个功能块。本章介绍模块声明、端口、例化连接与层次结构。

## 4.1 模块声明风格

=== "推荐：ANSI 风格（2001）"

    ```verilog
    module m (
        input  wire [3:0] a,
        output reg  [3:0] y
    );
        // 端口方向、类型在端口列表内一次声明
    endmodule
    ```

=== "旧式：两段式（Verilog-1995）"

    ```verilog
    module m (a, y);
        input  [3:0] a;
        output [3:0] y;
        reg    [3:0] y;   // output 为 reg 时需重复声明
    endmodule
    ```

!!! tip "推荐写法"
    一律使用 ANSI 风格：声明集中、减少重复、编译器能检查端口列表与实际声明的一致性。旧式仅用于维护遗留代码。

## 4.2 端口方向

| 方向 | 说明 |
|---|---|
| `input` | 输入：模块内只读，只能连接为 wire |
| `output` | 输出：模块内可驱动（连续赋值/过程赋值），**不能被模块内部读取** |
| `inout` | 双向：三态总线（见 7.9 节），模块内外都必须接 wire |

!!! warning "output 不能被模块内部读取"
    需要"输出又回读"（如状态机输出作为内部条件）时，用内部变量保存，再把内部变量赋给 output。

## 4.3 例化连接方式

=== "推荐：按名连接"

    ```verilog
    full_adder u1 (
        .a(a), .b(b), .cin(cin),
        .sum(s), .cout(cout)
    );
    ```

=== "按序连接"

    ```verilog
    full_adder u1 (a, b, cin, s, cout);
    ```

按序连接必须与端口定义顺序**完全一致**，位置写错编译器通常不报错（类型相同即合法），是隐蔽 bug 的温床；按名连接顺序无关，且 2001 起支持 `.name` 简写（信号名与端口同名时）。

## 4.4 层次结构与命名

- 例化形成层次树：`tb.u_dut.u_ha1` 即"测试台 → 被测模块 → 半加器"的点分层次路径
- **层次引用**（如 TB 中用 `tb.u_dut.s1` 访问内部信号）是**仿真特性**，❌ 不可综合，详见第 14 章
- 一个 `.v` 文件允许包含多个模块；模块名全局可见

## 4.5 门级结构描述

Verilog 内建门级原语可做结构描述（早期网表风格）：

```verilog
and (y, a, b);      // 输出在前，输入在后
or  (y, a, b);
xor (y, a, b);
not (y, a);
buf (y, a);
```

✅ 可综合，但现代工程中 RTL 基本不用（行为描述交给综合工具优化更优），主要用于门级网表后仿真。

## 4.6 示例

### 示例 04-1：门级半加器

```verilog
--8<-- "examples/04-modules/half_adder_gates.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/04-modules/half_adder_gates_tb.v"
    ```

### 示例 04-2：层次化全加器

```verilog
--8<-- "examples/04-modules/full_adder_hier.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/04-modules/full_adder_hier_tb.v"
    ```

### 示例 04-3：端口声明风格对比

```verilog
--8<-- "examples/04-modules/port_styles.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/04-modules/port_styles_tb.v"
    ```

### 示例 04-4：按序连接与按名连接

```verilog
--8<-- "examples/04-modules/named_connection.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/04-modules/named_connection_tb.v"
    ```
