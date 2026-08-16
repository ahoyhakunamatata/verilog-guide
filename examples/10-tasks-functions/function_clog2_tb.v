// function_clog2 自检测试台：例化多个位宽参数的实例验证
`timescale 1ns/1ps
module function_clog2_tb;
    reg  [15:0] din16;
    reg  [8:0]  din9;
    wire [3:0]  aw16, aw9;

    function_clog2 #(.WIDTH(16)) u16 (.din(din16), .addr_width(aw16));
    function_clog2 #(.WIDTH(9))  u9  (.din(din9),  .addr_width(aw9));

    initial begin
        din16 = 16'h0; din9 = 9'h0; #10;
        if (aw16 !== 4'd4) $display("FAIL aw16=%0d", aw16);   // clog2(16)=4
        if (aw9  !== 4'd4) $display("FAIL aw9=%0d", aw9);     // clog2(9)=4
        $display("PASS");
        $finish;
    end
endmodule
