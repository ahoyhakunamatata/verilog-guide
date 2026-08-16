// $display/$sformat 格式符演示（自包含）：用 $sformat 把格式化结果写进寄存器回读比对
// 注意 iverilog 行为：结果低端对齐存储（高位补零）；%0d/%0h 的 "0" 去除前导零
`timescale 1ns/1ps
module display_format_tb;
    reg [95:0] sbuf;   // 12 字符 x 8 位，容纳最长的格式化结果

    initial begin
        // %0d 与 %0h：前导零/空格被去除，得到紧凑形式
        $sformat(sbuf, "%0d-%0h", 32'd10, 16'hFF);
        if (sbuf[39:0] !== "10-ff") $display("FAIL sformat=[%s]", sbuf[39:0]);

        // %t 受 $timeformat 控制：-9 表示单位 ns，精度 2 位，后缀 " ns"，最小宽度 12
        // 时间值 1500 以 timescale 单位（ns）解释 → 1500ns
        $timeformat(-9, 2, " ns", 12);
        $sformat(sbuf, "%t", 1500);
        if (sbuf !== "  1500.00 ns") $display("FAIL timeformat=[%s]", sbuf);

        // %m 层次路径、%s 字符串（人工观察项，不参与比对）
        $display("module=%m string=%s", "hello");
        $display("PASS");
        $finish;
    end
endmodule
