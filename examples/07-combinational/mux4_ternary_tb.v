// mux4_ternary 自检测试台：与 mux4_case 相同的激励与期望输出
`timescale 1ns/1ps
module mux4_ternary_tb;
    reg  [1:0] sel;
    reg  [3:0] din;
    wire       dout;

    mux4_ternary u_dut (.sel(sel), .din(din), .dout(dout));

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
