# 18 附录·参考标准

本指南依据的标准与参考文档。

## 18.1 IEEE 标准

### IEEE Std 1364-2005（IEEE Standard for Verilog Hardware Description Language）

本指南的语言基准。1364-2005 是 Verilog HDL 的最后一版独立标准（此后并入 SystemVerilog 体系），相比 1364-2001 的变更主要为勘误与少量澄清，新增关键字仅有 `uwire`。

### IEEE Std 1364-2001

Verilog-2001，引入了本指南大量使用的特性：ANSI 端口声明、`generate`、`localparam`、`signed/unsigned`、`automatic`、`@(*)`、`` `default_nettype ``、`$sformat`、可变域选 `[base +: width]` 等。本指南以 1364-2005 为基准，2001 新增特性均有效。

### IEEE Std 1364.1-2002（IEEE Standard for Verilog Register Transfer Level Synthesis）

**RTL 可综合子集标准**——"可综合语法"的权威依据。它定义了 Verilog 中可用于 RTL 综合的语法子集及综合语义，本指南第 17 章的三表速查与各章的可综合性标注与其对齐。

### IEC 61691-4

IEEE 1364-2005 的 IEC 等同采用版本（IEC 61691-4:2016 对应 1364-2001/2005 系列），内容与 IEEE 版一致，仅发布机构不同。

### 与 IEEE 1800（SystemVerilog）的关系

SystemVerilog（IEEE 1800）是 Verilog 的超集，2009 年起 1800 标准吸收了 Verilog 全部内容。本指南**只覆盖 Verilog 子集**（1364-2005 范围）；文中出现的 `$clog2`、`$urandom`、`logic`、`always_ff` 等均为 SystemVerilog 特性，本指南仅作边界说明，不作为内容。

## 18.2 工程参考文档

| 文档 | 说明 |
|---|---|
| STARC RTL Design Style Guide (Verilog) | 日本 STARC 的 RTL 编码风格指南（日英双语公开版），行业流传最广的编码风格参考之一 |
| Reuse Methodology Manual（Keating & Bricaud, 2002） | 可复用 IP 设计方法学经典，命名/接口/文档规范的系统论述 |
| Icarus Verilog 文档与源码 | 本指南全部示例的验证工具链（iverilog 12.0 + vvp），在线文档见 iverilog.icarus.com |

## 18.3 标准获取渠道

- IEEE 标准库：ieeexplore.ieee.org（正式文本，收费）
- 各 EDA 工具文档中普遍附有 Verilog 语法支持对照表（Vivado/Quartus 等工具文档为免费获取）
- 互联网流传的 1364-2001/2005 草案与勘误文本（注意版本甄别）

## 18.4 术语中英对照

| 中文 | English |
|---|---|
| 网络 / 变量 | net / variable |
| 连续赋值 / 过程赋值 | continuous / procedural assignment |
| 阻塞 / 非阻塞赋值 | blocking / non-blocking assignment |
| 事件控制 / 延时控制 | event / delay control |
| 敏感列表 | sensitivity list |
| 锁存器 / 触发器 | latch / flip-flop |
| 例化 / 层次引用 | instantiation / hierarchical reference |
| 参数重载 | parameter override |
| 可综合子集 | synthesizable subset |
| 时序检查 | timing check |
| 测试平台 / 被测设计 | testbench / DUT (device under test) |
| 激励 / 自检 | stimulus / self-checking |
| golden 参考模型 | golden reference model |

## 18.5 本指南与标准的差异声明

1. **验证基准**：本指南所有示例以 **Icarus Verilog 12.0（`-g2005`）的实测行为**为准；标准条款与 iverilog 行为存在分歧处，以 iverilog 实测为准并在文中注明。
2. **已知工具差异**：`join_any`/`join_none`（1364-2001 特性）在 iverilog 12 的 `-g2005` 模式下不支持（`-g2012` 支持），故第 14 章未演示。
3. **未覆盖内容**：强度解析、开关级精确时序、PLI/VPI 接口、库建模（config/design 配置）等高级主题不在本指南范围。
4. **勘误**：若发现本指南示例与标准或仿真行为不符，欢迎按第 15 章约定的方式提交修正。
