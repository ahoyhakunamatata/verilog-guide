# 06 赋值语义与事件调度

赋值是 Verilog 语义的核心。本章澄清三种赋值的本质区别与事件调度模型——理解它们才能写出仿真与综合一致、时序正确的 RTL。

## 6.1 连续赋值（continuous assignment）

```verilog
assign y = a & b;   // 驱动 net（wire）
```

- 语法上**恒在驱动**：右侧任一操作数变化，左侧立即重新求值
- 只能驱动 net；✅ 可综合（组合逻辑的直写方式）
- 等价于门/开关的输出连接，是"连线级"描述

## 6.2 过程赋值：阻塞 vs 非阻塞

| 维度 | 阻塞 `=` | 非阻塞 `<=` |
|---|---|---|
| 语句内时序 | 立即更新左侧，后续语句读到新值 | 右侧在块开始时采样，左侧在时间步**末尾**统一更新 |
| 块内多条语句 | 顺序敏感 | 顺序无关（等价并行） |
| 典型用途 | ✅ 组合逻辑（`always @(*)`） | ✅ 时序逻辑（`always @(posedge clk)`） |
| 混用后果 | 同一块内混用极易产生仿真/综合不一致 | 同左 |

!!! danger "经典陷阱：阻塞赋值"移位""
    两个 `always @(posedge clk)` 中写 `q1 = d; q2 = q1;`（阻塞）时，`q2` 得到的是**新值**——两级寄存器同值，不是移位。示例 06-1 用 TB 实证了这一点。

## 6.3 简化事件调度模型

仿真器把每个时间步划分为事件区域（简化版）：

```text
active（普通阻塞赋值/连续赋值/门输出计算）
   ↓ 产生的新事件回到 active 继续处理
inactive（#0 延时的阻塞赋值）
   ↓
NBA 区域（非阻塞赋值更新——时间步末尾）
```

由此可以解释：

- 时钟沿块内 `q <= d; x = q;`：`x` 读到的是 `q` 的**旧值**（NBA 还没执行）——示例 06-2
- TB 中在时钟沿后想读到 NBA 结果：用 `#1` 小延时或等下一个沿
- 想观察 NBA 之后的最终值：用 `$strobe`/`$monitor`（见第 13 章）

## 6.4 推荐规则表

| 场景 | 赋值 | 敏感列表 |
|---|---|---|
| 组合逻辑 | 阻塞 `=` | `@(*)` |
| 时序逻辑（触发器） | 非阻塞 `<=` | `@(posedge clk)` 或 `@(posedge clk or negedge rst_n)` |
| 锁存器 | 非阻塞 `<=` | `@(*)`（门控敏感列表，见 7.10） |

!!! tip "四条铁律"
    1. 时序逻辑只用非阻塞，组合逻辑只用阻塞
    2. 同一变量只在一个 `always` 块中赋值（多驱动是 RTL 大忌）
    3. 时序块内不要混用两种赋值
    4. 时钟沿块内不要读"刚被非阻塞赋值"的变量（读到旧值易引入隐蔽 bug）

## 6.5 过程连续赋值（仅仿真）

- `assign`（过程语句内）/`deassign`：临时用连续赋值接管某个 reg，直到 `deassign` 释放
- `force`/`release`：更强的接管，可作用于 net 与 reg（常用于错误注入、强制测试点）

!!! danger "不可综合"
    `assign/deassign`、`force/release` 都仅用于仿真调试与故障注入，❌ 不可综合。示例 06-3 演示其语义。

## 6.6 示例

### 示例 06-1：阻塞 vs 非阻塞

```verilog
--8<-- "examples/06-assignments/blocking_vs_nba.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/06-assignments/blocking_vs_nba_tb.v"
    ```

### 示例 06-2：非阻塞更新的时间步位置

```verilog
--8<-- "examples/06-assignments/scheduling_order.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/06-assignments/scheduling_order_tb.v"
    ```

### 示例 06-3：过程连续赋值 assign/deassign

```verilog
--8<-- "examples/06-assignments/assign_deassign_demo.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/06-assignments/assign_deassign_demo_tb.v"
    ```

    TB 通过层次引用 `u_dut.q` 对 DUT 内部 reg 做 `assign`/`deassign`，演示"接管→保持→释放→恢复"的完整语义。
