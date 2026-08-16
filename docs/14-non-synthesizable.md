# 14 不可综合语法专章

!!! danger "本章内容全部不可综合"
    以下语法只在**仿真**中有意义（时序建模、测试激励、调试）。它们在 RTL 中出现会被综合工具拒绝或忽略。掌握它们的目的：看懂验证代码、写库模型、以及明确"什么不能写进 RTL"。

## 14.1 延时控制 `#`

- 精确时间推进：`#10` 阻塞当前进程 10 个时间单位
- 支持小数（`#10.5`），最小分辨率 = timescale 精度
- 在 TB 中产生波形/激励；**RTL 中出现 `#` 是典型错误**

### 示例 14-1：延时控制与小数延时

```verilog
--8<-- "examples/14-non-synthesizable/delay_control_tb.v"
```

## 14.2 fork/join 并行块

- `fork...join`：所有分支并行推进，join 等待**全部**完成
- `join_any`（任一完成即继续）/ `join_none`（不等待）为 2001 新增
- 分支内多条语句用 `begin/end` 封装

### 示例 14-2：fork/join

```verilog
--8<-- "examples/14-non-synthesizable/fork_join_tb.v"
```

!!! note "本工具链差异"
    Icarus Verilog 12 的 `-g2005` 模式不支持 `join_any`/`join_none`（需 `-g2012`），故本指南未演示，见第 18 章差异声明。

## 14.3 force/release 与 assign/deassign

- `force`：强制覆盖目标值（reg 或 net），期间所有其他驱动无效
- `release`：结束强制；**reg 保持被强制值**，直到下一次过程赋值（示例 14-3 实证）
- 过程连续赋值 `assign`/`deassign`：语义相近的临时接管（见示例 06-3）
- 典型用途：错误注入、强制测试点、`$sdf_annotate` 配合

### 示例 14-3：force/release

```verilog
--8<-- "examples/14-non-synthesizable/force_release_tb.v"
```

## 14.4 命名事件 event 与 `->` 触发

跨进程的同步原语：`event` 类型变量 + `->` 触发 + `@event` 等待。

### 示例 14-4：事件触发与等待

```verilog
--8<-- "examples/14-non-synthesizable/event_trigger_tb.v"
```

## 14.5 wait 语句

`wait (expr)`：条件成立才继续。功能可用 `@` + 条件替代，但 wait 语义更直接。❌ 不可综合。

## 14.6 层次引用（仿真探针）

TB 用点分路径（`u_dut.carry0`）直接读/写模块内部信号——调试利器，但破坏封装、❌ 不可综合。

### 示例 14-5：层次引用观察内部信号

```verilog
--8<-- "examples/14-non-synthesizable/hierarchical_ref_tb.v"
```

## 14.7 UDP 用户自定义原语

用真值表定义组合或时序原语（primitive）：库单元建模的传统手段，现代验证中已少见。

### 示例 14-6：UDP 真值表 MUX

```verilog
--8<-- "examples/14-non-synthesizable/udp_mux_tb.v"
```

## 14.8 specify 块与时序检查

- `specify...endspecify`：定义模块的路径延时与**时序检查**（$setup/$hold/$width/$recovery/$skew 等）
- 用于标准单元/IO 模型的精确时序建模；违例时仿真器报告 TIMING ERROR 但继续仿真
- 配套 `$sdf_annotate` 从 SDF 文件反标延时

### 示例 14-7：$setup 时序检查

```verilog
--8<-- "examples/14-non-synthesizable/timing_checks_tb.v"
```

    运行本示例会看到一条 TIMING ERROR 报告（setup 违例），这是期望行为：违例只报告、不中断仿真。

## 14.9 不可综合语法速查

| 语法 | 仿真用途 |
|---|---|
| `initial`、`#` 延时 | 激励与初始化 |
| `fork/join` | 并行激励 |
| `force/release`、`assign/deassign` | 错误注入、强制测试点 |
| `event`、`wait` | 进程同步 |
| 层次引用 | 内部信号观察 |
| UDP、specify、$setup 等时序检查 | 单元库建模 |
| `real`/`realtime`、强度与开关级原语 | 模拟电路行为建模 |
