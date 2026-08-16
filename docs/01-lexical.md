# 01 词法约定

本章介绍 Verilog 源文件的词法组成：注释、标识符、关键字、数字字面量与字符串。

## 1.1 注释

- **单行注释**：`//` 至行尾
- **块注释**：`/* ... */`，可以跨行，**不能嵌套**——块注释内再出现 `/*` 会被词法分析判定为注释提前结束（这正是编译器会给出 "Possible nested comment" 警告的场景）

!!! tip "推荐写法"
    文件头用块注释写模块功能说明，行内说明用 `//`。

## 1.2 标识符

- **常规标识符**：字母、数字、`$`、下划线组成，**首字符不能是数字**；**大小写敏感**（`data_bus` 与 `data_BUS` 是两个不同的标识符）
- **转义标识符**：以 `\` 开头、以空白字符（空格/Tab/换行）结束，中间可包含任意可打印字符

!!! warning "转义标识符慎用"
    转义标识符可读性差且容易出错（结尾空白即结束），工程代码中仅在迫不得已时使用。

## 1.3 关键字

Verilog 关键字全部小写，不能用作标识符。下表按用途分类（同一关键字只列一次），并标注版本新增：

| 类别 | 关键字 |
|---|---|
| 模块与声明 | `module` `endmodule` `macromodule` `primitive` `endprimitive` `input` `output` `inout` `wire` `reg` `integer` `real` `realtime` `time` `parameter` `localparam`^(2001) `specparam` `event` `genvar`^(2001) `signed`^(2001) `unsigned`^(2001) `scalared` `vectored` `small` `medium` `large` `automatic`^(2001) `generate`^(2001) `endgenerate`^(2001) `instance`^(2001) `cell`^(2001) |
| 网络类型 | `wand` `wor` `tri` `tri0` `tri1` `triand` `trior` `trireg` `supply0` `supply1` `uwire`^(2005) |
| 门级与开关 | `and` `nand` `or` `nor` `xor` `xnor` `not` `buf` `bufif0` `bufif1` `notif0` `notif1` `nmos` `pmos` `cmos` `rnmos` `rpmos` `rcmos` `tran` `tranif0` `tranif1` `rtran` `rtranif0` `rtranif1` `pullup` `pulldown` |
| 强度 | `strong0` `strong1` `pull0` `pull1` `weak0` `weak1` `highz0` `highz1` |
| 过程与时序 | `always` `initial` `begin` `end` `fork` `join` `if` `else` `case` `casex` `casez` `endcase` `default` `for` `while` `repeat` `forever` `wait` `disable` `posedge` `negedge` `edge` `assign` `deassign` `force` `release` `function` `endfunction` `task` `endtask` |
| specify 与时序检查 | `specify` `endspecify` `table` `endtable` `ifnone` `showcancelled`^(2001) `noshowcancelled`^(2001) `pulsestyle_onevent`^(2001) `pulsestyle_ondetect`^(2001) |
| 配置 | `config`^(2001) `endconfig`^(2001) `design`^(2001) `liblist`^(2001) `library`^(2001) `use`^(2001) `incdir`^(2001) `include`^(2001) |

!!! note "版本说明"
    ^(2001) 表示 IEEE 1364-2001 新增，^(2005) 表示 IEEE 1364-2005 新增（2005 版新增关键字仅有 `uwire`）。工程中常用的 `` `default_nettype ``、`` `timescale `` 等以反引号开头的是**编译指令**，不是关键字，见第 12 章。

## 1.4 数字字面量

完整形式：`<位宽>'<基数><值>`，位宽可省略（unsized）：

| 基数字符 | 含义 |
|---|---|
| `b` / `B` | 二进制 |
| `o` / `O` | 八进制 |
| `d` / `D` | 十进制 |
| `h` / `H` | 十六进制 |

要点：

- 位宽指定位数；值超过位宽时**截断高位**，不足时**左侧补零**（若最高位为 x/z 则补 x/z）
- 值中允许 `x`/`z`（`z` 也可写 `?`），x/z 在对应进制中占完整的一位数字宽度（如十六进制中 `8'hx` 是 4 位全 x）
- 下划线 `_` 可插在数字之间，仅作分隔
- 负数：负号作用于整个字面量，按二进制补码存为位宽位数
- **unsized 字面量**（如 `'d5`）位宽至少 32 位（依赖实现），与 sized 混用是常见的位宽 bug 来源——表达式规则见第 03 章

!!! warning "易错点"
    `-8'd5` 是"8 位补码的 -5"（即 `8'hFB`），而不是"5 取负后再扩位"。若将 `8'hFB` 赋给更宽的 signed 变量，高位按符号扩展。

## 1.5 字符串字面量

- 双引号包围的字符序列，**本质是 8 位 ASCII 字符的向量**（每个字符占 8 位），因此赋给 `reg` 时宽度必须 ≥ 字符数 × 8，不足则**截断**
- 支持 C 风格转义序列：`\n`（换行）、`\t`（制表）、`\\`（反斜杠）、`\"`（双引号）、`\ddd`（八进制 ASCII 码）
- 字符串**不能跨行**；不支持动态字符串（那是 SystemVerilog 的特性）

## 1.6 示例

### 示例 01-1：数字字面量

```verilog
--8<-- "examples/01-lexical/literals.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/01-lexical/literals_tb.v"
    ```

### 示例 01-2：标识符与注释

```verilog
--8<-- "examples/01-lexical/identifiers_comments.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/01-lexical/identifiers_comments_tb.v"
    ```

### 示例 01-3：字符串字面量

??? note "自包含演示（无独立设计模块）"

    ```verilog
    --8<-- "examples/01-lexical/strings_tb.v"
    ```

    注意演示中的两个陷阱：`greeting` 宽度若不足 40 位会截断；字符串宽度大于实际字符数时左侧补零。
