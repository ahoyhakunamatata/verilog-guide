# 02 数据类型

Verilog 数据类型分两大类：**网络（net）**与**变量（variable）**。理解两者的区别是掌握 Verilog 的关键。

## 2.1 四态值与强度

值系统为四态（4-state）：

| 值 | 含义 |
|---|---|
| `0` | 逻辑 0 / 假 |
| `1` | 逻辑 1 / 真 |
| `x` | 未知（未初始化、冲突等） |
| `z` | 高阻（未驱动/三态） |

强度（strength）用于描述多驱动网络的分辨规则（`strong` > `pull` > `weak` > `highz`），主要用于门级仿真建模，RTL 设计中基本用不到，详见第 14 章。

## 2.2 网络类型（net）

net 表示**连线**，其值由**驱动**（连续赋值、门输出、模块输出连接）决定；无驱动时为 `z`。

| 类型 | 语义 | 工程定位 |
|---|---|---|
| `wire` / `tri` | 普通连线（两者语义相同，`tri` 仅表意"多驱动"） | ✅ 可综合，最常用 |
| `wand` / `triand` | 线与：多驱动按"与"解析 | ⚠️ 慎用（开漏/总线建模） |
| `wor` / `trior` | 线或：多驱动按"或"解析 | ⚠️ 慎用 |
| `tri0` | 内建弱下拉：所有驱动为 z 时解析为 0 | ⚠️ 慎用 |
| `tri1` | 内建弱上拉：所有驱动为 z 时解析为 1 | ⚠️ 慎用 |
| `supply0` / `supply1` | 电源/地网络 | ⚠️ 特殊建模 |
| `trireg` | 带电荷保持能力的网络（开关级建模） | ❌ 不可综合 |
| `uwire` | 单驱动 wire（2005 新增，多驱动即报错） | ✅ 可综合，可用于严格检查 |

## 2.3 变量类型（variable）

variable 在**过程块**（`initial`/`always`）中赋值，赋值前为默认值。

| 类型 | 说明 | 综合 |
|---|---|---|
| `reg` | 可综合，过程赋值目标；注意：**名为 reg 不代表寄存器**，综合为锁存器/触发器还是组合逻辑取决于写法 | ✅ 可综合 |
| `integer` | 32 位有符号整数（循环变量、计算） | ✅ 可综合 |
| `time` | 64 位无符号时间值 | ❌ 不可综合 |
| `real` / `realtime` | 双精度浮点 | ❌ 不可综合 |

!!! danger "注意：reg 不一定生成寄存器"
    新手最容易误解的一点：`reg` 只是"过程赋值的存放目标"。`always @(*)` 里赋值的 `reg` 综合结果是**组合逻辑**；`always @(posedge clk)` 里赋值的 `reg` 才是触发器。生成什么电路由**赋值上下文**决定，不是由 `reg` 关键字决定。

## 2.4 参数（parameter / localparam）

```verilog
parameter  WIDTH = 8;       // 可被上层例化时重载（见第 11 章）
localparam MASK  = {WIDTH{1'b1}};   // 仅模块内部可见，不可重载
specparam  ...    // specify 块专用（见第 14 章），RTL 不用
```

!!! tip "推荐写法"
    对外可见、希望上层可配置的量用 `parameter`；纯内部推导常量用 `localparam`。参数命名全大写。

## 2.5 向量、位选与域选

- **标量**：1 位（如 `wire a;`）；**向量**：多位（如 `wire [7:0] data;`）
- **位选**：`data[3]`——取单比特
- **域选**：`data[7:4]`——取连续多位，**边界必须是常量表达式**
- **可变域选**（2001）：`data[base +: width]` 或 `data[base -: width]`——`base` 可以是变量，宽度恒定；当"起点随变量变化"时只能用它（常量域选的 `[i+3:i]` 写法非法，且 +:/-: 形式不受左右边界书写顺序影响）

## 2.6 存储器数组

```verilog
reg [7:0] mem [0:3];   // 4 个 8 位元素的存储器
```

- 只能**整体访问元素**（`mem[addr]`）；Verilog 不支持 `mem[addr][bit]` 的多级选择（SystemVerilog 才支持）
- 向量（bit 选择）与数组（字选择）是两个维度：先声明向量再声明数组维度
- 综合时推断为 RAM/寄存器堆

## 2.7 示例

### 示例 02-1：wire 与 reg 的本质区别

```verilog
--8<-- "examples/02-data-types/wire_reg.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/02-data-types/wire_reg_tb.v"
    ```

### 示例 02-2：位选与域选

```verilog
--8<-- "examples/02-data-types/vector_select.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/02-data-types/vector_select_tb.v"
    ```

### 示例 02-3：可变域选 [base +: width]

```verilog
--8<-- "examples/02-data-types/part_select.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/02-data-types/part_select_tb.v"
    ```

### 示例 02-4：存储器数组

```verilog
--8<-- "examples/02-data-types/memory.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/02-data-types/memory_tb.v"
    ```

### 示例 02-5：其他网络类型

```verilog
--8<-- "examples/02-data-types/other_net_types.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/02-data-types/other_net_types_tb.v"
    ```
