# 17 可综合性检查清单

本章是全指南可综合性规则的汇总速查，也是 RTL 交付前的自检清单。

## 17.1 可综合 / 慎用 / 不可综合 三表速查

### ✅ 可综合（RTL 主体）

| 类别 | 语法 |
|---|---|
| 声明 | `module`、`input/output/inout`、`wire`、`reg`、`integer`、`parameter/localparam`、`genvar` |
| 连续赋值 | `assign`（驱动 net） |
| 过程块 | `always @(*)`（组合）、`always @(posedge clk)` 及含异步复位沿的变体 |
| 语句 | `if/else`、`case`（写全 default）、`for`（边界静态）、`begin/end`、`case` 项 |
| 赋值 | 组合用阻塞 `=`、时序用非阻塞 `<=` |
| 操作符 | 全部算术/关系/逻辑/位/移位/拼接/条件操作符（`===`/`!==` 除外） |
| 层次 | 模块例化（按名连接）、`function`（无时序控制）、generate 三件套 |
| 指令 | `` `define ``、`` `include ``、`` `ifdef `` 系列、`` `default_nettype none `` |

### ⚠️ 慎用（依赖工具或易出问题）

| 语法 | 风险 |
|---|---|
| `casez` / `casex` | x/z 吞没；重叠项隐式优先级 |
| `full_case`/`parallel_case` 伪指令 | 仿真与综合不一致 |
| `while` 循环 | 要求静态可展开，多数工具不支持 |
| `wand`/`wor`/`tri0`/`tri1` | 仅特定建模场景（开漏总线等） |
| `inout` 内部三态 | 多数工艺不可实现，DFT 困难 |
| 递归 `function` | 仅静态展开时可能支持 |
| 移位量非静态 | 部分工具不支持可变移位量 |
| 组合输出分频时钟（`assign clk_div = cnt[N]`） | 毛刺、时钟树问题（见 8.6 节） |
| signed/unsigned 隐式混合 | 行为正确性依赖规则记忆 |

### ❌ 不可综合（仅仿真）

| 语法 | 见章节 |
|---|---|
| `initial`、`#` 延时、`wait`、`fork/join`、`event`/`->` | 第 14 章 |
| `force/release`、过程连续 `assign/deassign` | 6.5、14.3 节 |
| `real`/`realtime`/`time` 变量 | 2.3 节 |
| 层次引用 | 14.6 节 |
| UDP、specify 块、时序检查、`$sdf_annotate` | 14.7、14.8 节 |
| 全部系统任务/函数（`$display` 等） | 第 13 章 |
| `` `timescale ``（对综合无意义，但 TB 需要） | 12.5 节 |
| 强度、开关级原语（tran 类） | 2.2 节 |

## 17.2 交付前自检清单

**仿真通过是前提**，然后逐项检查：

- [ ] 无 `initial` 块、无 `#` 延时、无系统任务（RTL 部分）
- [ ] 组合逻辑：所有 `always @(*)` 块内**每个输出在所有分支都有赋值**（无意外锁存，7.7 节）
- [ ] 时序逻辑：敏感列表只有时钟沿（+异步复位沿）；块内全非阻塞；复位分支覆盖所有被驱动寄存器
- [ ] 无多驱动：每个变量只在一个 `always`/`assign` 中赋值
- [ ] 位宽：加法/乘法等运算的 LHS 位宽足以容纳结果（3.5 节）
- [ ] case 写全 default；if-else 链完整
- [ ] 无 `===`/`!==`（RTL 中）
- [ ] 无内部三态总线；inout 只用于顶层 IO
- [ ] 无手工门控时钟/组合逻辑分频时钟；功耗优化交给时钟使能或后端 ICG
- [ ] 无 signed/unsigned 隐式混合
- [ ] 命名规范一致（第 16 章）；一模块一文件
- [ ] 综合工具报告的 latch 推断、位宽截断、组合环警告全部处理完毕

## 17.3 常见综合警告与处理

| 警告 | 原因 | 处理 |
|---|---|---|
| latch inferred | 组合块条件不完整 | 补全 else/default（7.7 节） |
| width truncated | 赋值位宽不足 | 检查 LHS 位宽与上下文规则（3.5 节） |
| combinational loop | 组合逻辑形成环 | 检查输出是否回连到自身输入路径 |
| multiple drivers | 同一信号多处驱动 | 合并驱动（6.4 节铁律 2） |
| unused signal | 未连接/未使用 | 确认意图，清理或显式标注 |
| case not full/parallel | case 缺项/期望并行 | 写全项或确认优先级意图（5.3 节） |
