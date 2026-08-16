# 05 过程语句

过程语句是行为描述的核心：`always` 与 `initial` 块内的语句描述电路或仿真行为。

## 5.1 initial 与 always

| 块 | 执行方式 | 定位 |
|---|---|---|
| `initial` | 从时刻 0 起执行**一次** | ❌ 不可综合：仅用于 TB 初始化/激励 |
| `always` | 由敏感列表触发，循环执行 | ✅ 可综合（RTL 主要载体）；TB 中也可用于产生时钟 |

## 5.2 事件控制

| 形式 | 含义 | 综合 |
|---|---|---|
| `@(a or b)` | 信号变化触发 | ✅ 组合逻辑用 `@(*)` 简写（2001） |
| `@(posedge clk)` | 上升沿触发 | ✅ 时序逻辑 |
| `@(posedge clk or negedge rst_n)` | 沿列表（异步复位） | ✅ |
| `#delay` | 延时（阻塞该块推进） | ❌ 仅仿真 |
| `wait (expr)` | 条件成立才继续 | ❌ 仅仿真 |

!!! tip "推荐写法"
    组合逻辑一律 `always @(*)`（工具自动补全敏感列表，杜绝漏信号产生的仿真/综合不一致）；时序逻辑敏感列表只放时钟沿与异步复位沿。

## 5.3 条件语句

### if-else

- 条件依次判断，**隐含优先级**：综合为优先链（priority chain）
- 组合逻辑中不完整 if-else 会产生**锁存器**（见 7.10 节）

### case / casez / casex

- `case`：精确匹配，与 if-else 链相比**项之间并行**，综合为并行选择（MUX）
- `casez`：z/? 位作通配符；`casex`：x/z/? 位都作通配符

!!! danger "casez/casex 的两大陷阱"
    1. **x/z 吞没**：仿真中信号带 x 或 z 时会被当作通配符匹配，掩盖真实 bug——本指南示例 05-3 的 TB 演示了 `sel=2'bz1` 被第一项吞掉的行为
    2. **重叠项隐式优先级**：多个项同时匹配时**先匹配者胜**，与 `case` 的"并行"直觉不同

!!! warning "full_case / parallel_case 伪指令慎用"
    `// synopsys full_case` 等综合伪指令声称消除锁存/优先级，但会制造**仿真与综合不一致**：仿真仍按语义走（优先级、锁存），综合却按并行处理。正确做法永远是**写全 default、写全条件**。

## 5.4 循环语句

| 语句 | 说明 | 综合 |
|---|---|---|
| `for` | 迭代变量（integer）、边界静态可确定时可展开 | ✅ 可综合 |
| `while` | 条件循环 | ⚠️ 慎用（工具常要求静态可展开） |
| `repeat` | 固定次数 | ❌ 仿真用 |
| `forever` | 无限循环 | ❌ 仿真用（时钟产生） |

## 5.5 命名块与 disable

- `begin : name` 命名块：块内可声明局部变量（2001），提供层次命名点
- `disable name;`：提前终止命名块——用于错误处理，❌ 不可综合

## 5.6 示例

### 示例 05-1：同步复位与异步复位

```verilog
--8<-- "examples/05-procedural/always_event.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/05-procedural/always_event_tb.v"
    ```

    TB 用 `task tick` 手动打拍，使"异步复位立即生效、同步复位等待时钟"的对比在时序上完全确定。

### 示例 05-2：if-else 链与 case

```verilog
--8<-- "examples/05-procedural/if_case.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/05-procedural/if_case_tb.v"
    ```

### 示例 05-3：casez 的隐式优先级与 x/z 吞没

```verilog
--8<-- "examples/05-procedural/case_implicit_priority.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/05-procedural/case_implicit_priority_tb.v"
    ```

### 示例 05-4：for 循环

```verilog
--8<-- "examples/05-procedural/loops.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/05-procedural/loops_tb.v"
    ```
