# 11 参数化与 generate

参数化让一个模块适配多种位宽/深度/结构，是 IP 复用的基础。

## 11.1 parameter 与 localparam

- `parameter`：可被上层例化重载；`localparam`：模块内部常量，不可重载
- 重载方式：例化时 `#(.PARAM(value))`（✅ 推荐）或 `defparam`（❌ 不推荐：靠层次路径字符串定位目标，层次一改就静默失效）

### 示例 11-1：参数化位宽模块

```verilog
--8<-- "examples/11-params-generate/param_width.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/11-params-generate/param_width_tb.v"
    ```

### 示例 11-2：参数重载的两种方式

```verilog
--8<-- "examples/11-params-generate/param_override.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/11-params-generate/param_override_tb.v"
    ```

## 11.2 generate

generate 在 **elaboration 期**（编译后、仿真前）展开，产生多个实例/语句，不是运行时逻辑。

- `generate for` + `genvar`：循环例化多份相同结构
- `generate if` / `generate case`：按参数选择不同结构（常用于备选实现切换）
- 块内 `begin : name` 命名，形成层次路径（`u_dut.gen_block[3].u_x`）

### 示例 11-3：generate for 异或树

```verilog
--8<-- "examples/11-params-generate/gen_for_parity.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/11-params-generate/gen_for_parity_tb.v"
    ```

### 示例 11-4：generate if 结构选择

```verilog
--8<-- "examples/11-params-generate/gen_if_case.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/11-params-generate/gen_if_case_tb.v"
    ```

!!! tip "generate 与普通 for 的区别"
    普通 `for` 在 `always` 块内（过程语句，可综合时被展开为电路）；`generate for` 在模块层例化**硬件实例**。二者不可互相替代。
