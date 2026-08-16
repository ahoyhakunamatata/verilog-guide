// scheduling_order 自检测试台
`timescale 1ns/1ps
module scheduling_order_tb;
    reg  clk, d;
    wire q, shadow;

    scheduling_order u_dut (.clk(clk), .d(d), .q(q), .shadow(shadow));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    initial begin
        clk = 0; d = 0;
        tick; #1;   // 第一个沿：q 由 x 变为 0
        if (q !== 1'b0) $display("FAIL q after 1st=%b", q);
        d = 1; tick; #1;
        if (q      !== 1'b1) $display("FAIL q=%b", q);
        if (shadow !== 1'b0) $display("FAIL shadow should be old q=%b", shadow);
        $display("PASS");
        $finish;
    end
endmodule
