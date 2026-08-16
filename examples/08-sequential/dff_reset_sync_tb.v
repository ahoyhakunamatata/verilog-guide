// dff_reset_sync 自检测试台：复位必须等时钟沿
`timescale 1ns/1ps
module dff_reset_sync_tb;
    reg  clk, rst_n, d;
    wire q;

    dff_reset_sync u_dut (.clk(clk), .rst_n(rst_n), .d(d), .q(q));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    initial begin
        clk = 0; rst_n = 1; d = 1;
        tick; #1;
        if (q !== 1'b1) $display("FAIL set=%b", q);
        rst_n = 0; #15;   // 无时钟沿：同步复位不生效
        if (q !== 1'b1) $display("FAIL sync reset waits clock=%b", q);
        tick; #1;         // 时钟沿到来才复位
        if (q !== 1'b0) $display("FAIL sync reset at clock=%b", q);
        rst_n = 1; tick; #1;
        if (q !== 1'b1) $display("FAIL recover=%b", q);
        $display("PASS");
        $finish;
    end
endmodule
