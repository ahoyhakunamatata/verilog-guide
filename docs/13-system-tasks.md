# 13 系统任务与函数

!!! danger "本章内容全部不可综合"
    系统任务与函数以 `$` 开头，全部仅用于仿真（显示、文件、时间、波形等）。RTL 中出现系统任务即视为仿真专用代码（通常用条件编译隔离，见第 12 章）。

## 13.1 显示类：$display / $write / $strobe / $monitor

| 任务 | 执行时机 |
|---|---|
| `$display` / `$write` | 执行到语句时（active 区）——后者不换行 |
| `$strobe` | **时间步末尾**——看到非阻塞赋值后的最终值 |
| `$monitor` | 监测的任一信号**变化时**打印（每时间步至多一次） |

常用格式符：`%d` `%0d` `%b` `%h` `%o` `%s` `%c` `%t` `%m` `%e/%f`（real）；`%0d` 的 `0` 表示去除前导零/空格。

### 示例 13-1：格式符与 $timeformat

```verilog
--8<-- "examples/13-system-tasks/display_format_tb.v"
```

### 示例 13-2：$strobe 的执行时机

```verilog
--8<-- "examples/13-system-tasks/monitor_strobe_tb.v"
```

    该 TB 用文件捕获 `$fdisplay` 与 `$fstrobe` 的输出顺序并回读比对，机器验证了"strobe 在时间步末尾看到 NBA 后的值"。

## 13.2 仿真控制：$finish / $stop

- `$finish;`：结束仿真（本指南所有 TB 的结尾）
- `$stop;`：暂停仿真（交互式调试）

## 13.3 时间函数：$time / $stime / $realtime

- `$time`：64 位整数，单位 = 当前模块 timescale 的单位
- `$realtime`：real，可表示小数时间（精度内的非整数时刻）

## 13.4 文件 I/O

| 函数/任务 | 作用 |
|---|---|
| `$fopen("name", "w"/"r"/"a")` | 打开文件，返回描述符（0 = 失败） |
| `$fdisplay` `$fwrite` `$fstrobe` `$fmonitor` | 格式化写入文件 |
| `$fscanf` | 按格式读入变量 |
| `$fclose` | 关闭文件 |
| `$readmemh` / `$readmemb` | 从文件批量加载存储器（hex/bin），ROM 初始化标准方式 |
| `$sformat` | 格式化到寄存器（字符串比较用，见示例 13-1） |

### 示例 13-3：文件写入与回读

```verilog
--8<-- "examples/13-system-tasks/file_io_tb.v"
```

### 示例 13-4：$readmemh 加载 ROM

=== "rom.hex（数据文件）"

    ```text
    --8<-- "examples/13-system-tasks/rom.hex"
    ```

=== "readmem_tb.v"

    ```verilog
    --8<-- "examples/13-system-tasks/readmem_tb.v"
    ```

## 13.5 波形转储：$dumpfile / $dumpvars

```verilog
$dumpfile("wave.vcd");          // 输出文件
$dumpvars(0, top_module);       // 转储某层次及其以下全部信号
```

生成的 VCD 可用 GTKWave 等工具查看。

### 示例 13-5：VCD 转储

```verilog
--8<-- "examples/13-system-tasks/vcd_dump_tb.v"
```

## 13.6 其他常用项

| 名称 | 用途 |
|---|---|
| `$random(seed)` | 伪随机数（32 位有符号）——激励生成常用 |
| `$value$plusargs` | 读取仿真命令行 `+name=value` 参数 |
| `$fatal` | 致命错误退出仿真（本指南 FAIL 判定的另一途径） |

> 注意：`$urandom`、`$clog2`、`$sformatf` 等是 SystemVerilog 的扩展，不属于 IEEE 1364-2005。
