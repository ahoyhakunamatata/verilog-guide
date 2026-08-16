// mux4_case 自检测试台：遍历全部选择值并与期望输出比对
`timescale 1ns/1ps
module mux4_case_tb;
    reg  [1:0] sel;
    reg  [3:0] din;
    wire       dout;

    mux4_case u_dut (.sel(sel), .din(din), .dout(dout));

    initial begin
        din = 4'b1010;
        sel = 2'd0; #10;
        if (dout !== 1'b0) $display("FAIL sel=0 dout=%b", dout);
        sel = 2'd1; #10;
        if (dout !== 1'b1) $display("FAIL sel=1 dout=%b", dout);
        sel = 2'd2; #10;
        if (dout !== 1'b0) $display("FAIL sel=2 dout=%b", dout);
        sel = 2'd3; #10;
        if (dout !== 1'b1) $display("FAIL sel=3 dout=%b", dout);
        $display("PASS");
        $finish;
    end
endmodule
