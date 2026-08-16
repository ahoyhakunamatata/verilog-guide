// define_macro 自检测试台
`timescale 1ns/1ps
module define_macro_tb;
    reg  [7:0] a, b;
    wire [7:0] sum;

    define_macro u_dut (.a(a), .b(b), .sum(sum));

    initial begin
        a = 8'd100; b = 8'd155; #10;
        if (sum !== 8'd255) $display("FAIL sum=%0d", sum);
        a = 8'd200; b = 8'd100; #10;   // 300 超出 8 位：截断为 44
        if (sum !== 8'd44) $display("FAIL trunc=%0d", sum);
        $display("PASS");
        $finish;
    end
endmodule
