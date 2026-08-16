// dff_reset_async 自检测试台：复位不依赖时钟
`timescale 1ns/1ps
module dff_reset_async_tb;
    reg  clk, rst_n, d;
    wire q;

    dff_reset_async u_dut (.clk(clk), .rst_n(rst_n), .d(d), .q(q));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    initial begin
        clk = 0; rst_n = 1; d = 1;
        tick; #1;
        if (q !== 1'b1) $display("FAIL set=%b", q);
        rst_n = 0; #15;   // 无时钟沿：异步复位立即生效
        if (q !== 1'b0) $display("FAIL async reset=%b", q);
        rst_n = 1; #15;   // 复位释放后无时钟沿：保持 0
        if (q !== 1'b0) $display("FAIL hold after reset=%b", q);
        tick; #1;
        if (q !== 1'b1) $display("FAIL recover=%b", q);
        $display("PASS");
        $finish;
    end
endmodule
