// shift_reg 自检测试台：串行送入 4 位数据，检查并行输出
`timescale 1ns/1ps
module shift_reg_tb;
    reg        clk, rst_n, sdi;
    wire [3:0] q;

    shift_reg u_dut (.clk(clk), .rst_n(rst_n), .sdi(sdi), .q(q));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    initial begin
        clk = 0; rst_n = 0; sdi = 0;
        tick; #1;
        if (q !== 4'b0000) $display("FAIL reset=%b", q);
        rst_n = 1;
        sdi = 1; tick; #1;   // q = 0001
        sdi = 0; tick; #1;   // q = 0010
        sdi = 1; tick; #1;   // q = 0101
        sdi = 1; tick; #1;   // q = 1011
        if (q !== 4'b1011) $display("FAIL shift=%b", q);
        $display("PASS");
        $finish;
    end
endmodule
