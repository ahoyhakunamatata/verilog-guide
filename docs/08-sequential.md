# 08 时序逻辑典型电路与推荐写法

!!! success "本章全部示例均可综合"
    时序逻辑 RTL 的唯一正确模板：**`always @(posedge clk)`（或含异步复位沿）+ 非阻塞赋值**。

## 8.1 D 触发器

### 示例 08-1：基本 D 触发器

```verilog
--8<-- "examples/08-sequential/dff_basic.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/08-sequential/dff_basic_tb.v"
    ```

## 8.2 复位方式：同步 vs 异步

=== "异步复位"

    ```verilog
    --8<-- "examples/08-sequential/dff_reset_async.v"
    ```

=== "同步复位"

    ```verilog
    --8<-- "examples/08-sequential/dff_reset_sync.v"
    ```

| 维度 | 异步复位 | 同步复位 |
|---|---|---|
| 生效时机 | 复位沿立即生效（不依赖时钟） | 时钟沿采样复位 |
| 敏感列表 | `@(posedge clk or negedge rst_n)` | `@(posedge clk)` |
| 复位释放风险 | 释放沿若接近时钟沿可能产生亚稳态/竞争 | 无此问题，时序干净 |
| 可测性 | 复位需要走测试网络（DFT 需特殊处理） | 与普通数据路径一致，DFT 友好 |
| 典型用途 | ASIC 上电复位 | FPGA 主流（寄存器自带同步复位）；ASIC 高可靠性场景 |

!!! tip "推荐写法"
    复位**低有效**（`rst_n`），与芯片上电默认电平一致；一个模块内只选一种复位风格，全芯片统一由复位架构文档约束。

??? note "配套自检测试台"

    === "异步复位"

        ```verilog
        --8<-- "examples/08-sequential/dff_reset_async_tb.v"
        ```

    === "同步复位"

        ```verilog
        --8<-- "examples/08-sequential/dff_reset_sync_tb.v"
        ```

## 8.3 寄存器与时钟使能

### 示例 08-2：带时钟使能的寄存器

```verilog
--8<-- "examples/08-sequential/register_enable.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/08-sequential/register_enable_tb.v"
    ```

!!! tip "时钟使能 vs 门控时钟"
    给寄存器组降功耗用**时钟使能**（en 进数据通路）或由后端做**门控时钟**（ICG cell）；**不要在 RTL 里手工 `clk & en` 产生门控时钟**——毛刺、时钟树失衡、可测性问题都会找上门。

## 8.4 计数器

### 示例 08-3：BCD 计数器

```verilog
--8<-- "examples/08-sequential/counter_bcd.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/08-sequential/counter_bcd_tb.v"
    ```

## 8.5 移位寄存器

### 示例 08-4：串转并移位寄存器

```verilog
--8<-- "examples/08-sequential/shift_reg.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/08-sequential/shift_reg_tb.v"
    ```

## 8.6 分频器

### 示例 08-5：4 分频

```verilog
--8<-- "examples/08-sequential/clk_divider.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/08-sequential/clk_divider_tb.v"
    ```

!!! warning "分频输出作时钟的坏习惯"
    `clk_div4` 是组合逻辑（`cnt[1]`）输出的"时钟"，存在毛刺与时钟树问题。**正确姿势**：
    1. 片内逻辑分频：优先用**时钟使能**（`cnt` 到顶时产生一个周期宽 `en` 脉冲，下游逻辑用 `clk` + `en`），或
    2. 必须真实分频时钟时：用 PLL/MMCM（FPGA）或后端时钟模块（ASIC）。
    本例仅用于演示计数分频原理。

## 8.7 寄存器组

### 示例 08-6：地址译码写入的寄存器组

```verilog
--8<-- "examples/08-sequential/register_bank.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/08-sequential/register_bank_tb.v"
    ```

## 8.8 时序逻辑写作检查要点

- ✅ 敏感列表只有时钟沿（+ 异步复位沿）
- ✅ 块内一律非阻塞赋值
- ✅ 每个时序 always 块只驱动一组相关寄存器
- ✅ 复位分支赋值覆盖**所有**被驱动的寄存器（漏掉的在复位时保持 x，仿真与综合行为不一致）
- ❌ 不要在时钟沿块里产生组合输出（会被多打一拍，逻辑错位）
- ❌ 不要用 `#` 延时描述电路时序
