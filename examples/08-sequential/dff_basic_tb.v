// dff_basic 自检测试台
`timescale 1ns/1ps
module dff_basic_tb;
    reg  clk, d;
    wire q;

    dff_basic u_dut (.clk(clk), .d(d), .q(q));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    initial begin
        clk = 0; d = 0;
        tick; #1;
        if (q !== 1'b0) $display("FAIL load 0=%b", q);
        d = 1; tick; #1;
        if (q !== 1'b1) $display("FAIL load 1=%b", q);
        d = 0; #15;   // 无时钟沿：q 保持
        if (q !== 1'b1) $display("FAIL hold=%b", q);
        $display("PASS");
        $finish;
    end
endmodule
