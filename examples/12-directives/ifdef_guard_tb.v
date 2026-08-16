// ifdef_guard 自检测试台：当前编译配置下 ENABLE_FEATURE 已定义
`timescale 1ns/1ps
module ifdef_guard_tb;
    reg  [7:0] din;
    wire [7:0] dout;

    ifdef_guard u_dut (.din(din), .dout(dout));

    initial begin
        din = 8'hA5; #10;
        if (dout !== 8'hA6) $display("FAIL dout=%h", dout);
        din = 8'hFF; #10;
        if (dout !== 8'h00) $display("FAIL wrap=%h", dout);
        $display("PASS");
        $finish;
    end
endmodule
