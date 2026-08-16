// fsm_onehot 自检测试台：与 fsm_moore_3stage 相同序列与期望
`timescale 1ns/1ps
module fsm_onehot_tb;
    reg  clk, rst_n, din;
    wire detect;

    fsm_onehot u_dut (.clk(clk), .rst_n(rst_n), .din(din), .detect(detect));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    integer k;
    reg [7:0] seq;
    initial begin
        clk = 0; rst_n = 0; din = 0; seq = 8'b1101_1010;
        tick; #1;
        if (detect !== 1'b0) $display("FAIL reset=%b", detect);
        rst_n = 1;
        for (k = 0; k < 8; k = k + 1) begin
            din = seq[7 - k];
            tick; #1;
            if (detect !== ((k == 3) || (k == 6))) $display("FAIL k=%0d detect=%b", k, detect);
        end
        $display("PASS");
        $finish;
    end
endmodule
