# 15 测试平台编写基础

!!! danger "本章内容仅仿真"
    测试平台（testbench，TB）不参与综合。本章同时是本指南 **PASS/FAIL 验证约定的正式定义**——本指南全部示例的验证都由这套约定驱动。

## 15.1 TB 结构四要素

一个合格的 TB 由四部分组成：

1. **信号声明**：连接 DUT 的驱动与观测信号
2. **被测模块例化**（DUT）
3. **激励生成**：驱动输入信号产生测试场景
4. **自检**：比对实际输出与期望值，输出 PASS/FAIL 结论

### 示例 15-1：TB 四要素结构

```verilog
--8<-- "examples/15-testbenches/tb_structure_tb.v"
```

## 15.2 时钟与复位生成

=== "方法一：always + 半周期延时（推荐）"

    ```verilog
    always #5 clk = ~clk;   // 10ns 周期；初始值在 initial 中给出
    ```

=== "方法二：initial + forever"

    ```verilog
    initial begin
        clk = 1'b1;         // 可精确控制初始相位
        forever #5 clk = ~clk;
    end
    ```

复位序列：上电后保持复位若干周期再释放：

```verilog
initial begin
    rst_n = 1'b0;      // 上电复位
    #25 rst_n = 1'b1;  // 2.5 个周期后释放
end
```

### 示例 15-2：时钟与复位生成（含时序验证）

```verilog
--8<-- "examples/15-testbenches/tb_clock_reset_tb.v"
```

    注意 TB 中采样检查的时刻刻意避开时钟翻转沿（5ns 的整数倍），避免读值竞争——这是 TB 写作的基本素养。

## 15.3 自检设计与 PASS/FAIL 约定（本指南规范）

本指南所有示例 TB 遵循同一套约定（由 `tools/verify_examples.py` 强制检查）：

- **必须**包含字面量 `$display("PASS");` 与 `$finish;`
- 失败用 `$display("FAIL ...");`（**行首** FAIL 会被验证脚本捕获）
- 推荐用 `n_errors` 计数 + 末尾汇总判定，便于定位全部错误
- 比较可能含 x/z 的信号用 `===`/`!==`（见 3.2 节）

### 示例 15-3：自检范式（错误计数 + 汇总判定）

```verilog
--8<-- "examples/15-testbenches/tb_selfcheck_tb.v"
```

## 15.4 golden 比对

**golden 参考模型**：在 TB 中用与 DUT **不同的实现方式**写出等价行为，逐拍比对。两者实现路径独立，互为印证，能抓住"实现错误但激励巧合通过"的问题。

### 示例 15-4：DUT 与 golden 模型逐拍比对

```verilog
--8<-- "examples/15-testbenches/tb_golden_compare_tb.v"
```

## 15.5 其他验证手段

| 手段 | 说明 |
|---|---|
| `$monitor` | 信号变化时打印，观察时序关系（第 13 章） |
| VCD 波形 | `$dumpfile`/`$dumpvars` + GTKWave 可视化（示例 13-5） |
| 回归 | 所有 TB 一键重跑：`python tools/verify_examples.py`（本指南的回归入口） |
