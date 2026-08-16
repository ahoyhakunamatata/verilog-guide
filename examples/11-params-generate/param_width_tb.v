// param_width 自检测试台：默认位宽与重载位宽两个实例
`timescale 1ns/1ps
module param_width_tb;
    reg  [7:0] din8;
    reg  [3:0] din4;
    wire [7:0] dout8;
    wire [3:0] dout4;

    param_width               u8 (.din(din8), .dout(dout8));   // 默认 WIDTH=8
    param_width #(.WIDTH(4))  u4 (.din(din4), .dout(dout4));   // 重载为 4

    initial begin
        din8 = 8'b1000_0001; #10;
        if (dout8 !== 8'b1100_0000) $display("FAIL dout8=%b", dout8);
        din4 = 4'b1001; #10;
        if (dout4 !== 4'b1100) $display("FAIL dout4=%b", dout4);
        $display("PASS");
        $finish;
    end
endmodule
