// 字符串字面量（自包含演示）：8 位 ASCII 向量，支持 C 风格转义序列
`timescale 1ns/1ps
module strings_tb;
    reg [5*8-1:0] greeting;      // 字符串宽度必须 >= 字符数*8（"hello" 为 5 字符 = 40 位）
    reg [3*8-1:0] padded;        // 宽度大于字符串时左侧补零
    reg [7:0]     backslash;
    reg [7:0]     newline_char;

    initial begin : demo
        reg [3*8-1:0] local_copy;
        greeting     = "hello";
        padded       = "ab";     // 实际存储 24'h006162
        backslash    = "\\";     // 转义：反斜杠本身
        newline_char = "\n";     // 转义：换行符（单字符 0x0A）
        local_copy   = "xy";     // 命名块内的局部声明（Verilog-2001）
        #10;
        if (greeting     !== "hello")  $display("FAIL greeting");
        if (padded       !== 24'h006162) $display("FAIL padded=%h", padded);
        if (backslash    !== 8'h5C)     $display("FAIL backslash=%h", backslash);
        if (newline_char !== 8'h0A)     $display("FAIL newline=%h", newline_char);
        if (local_copy   !== {8'h78, 8'h79}) $display("FAIL local_copy=%h", local_copy);
        $display("PASS");
        $finish;
    end
endmodule
