// fsm_moore_3stage 自检测试台：输入序列 1101101，应在第 4、7 位完成检测
`timescale 1ns/1ps
module fsm_moore_3stage_tb;
    reg  clk, rst_n, din;
    wire detect;

    fsm_moore_3stage u_dut (.clk(clk), .rst_n(rst_n), .din(din), .detect(detect));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    integer k;
    reg [7:0] seq;   // 序列 1101101 + 尾 0
    initial begin
        clk = 0; rst_n = 0; din = 0; seq = 8'b1101_1010;
        tick; #1;   // 复位
        if (detect !== 1'b0) $display("FAIL reset=%b", detect);
        rst_n = 1;
        for (k = 0; k < 8; k = k + 1) begin
            din = seq[7 - k];   // 高位先送入
            tick; #1;
            // 匹配位置：第 4 位（k=3）与第 7 位（k=6）
            if (detect !== ((k == 3) || (k == 6))) $display("FAIL k=%0d detect=%b", k, detect);
        end
        $display("PASS");
        $finish;
    end
endmodule
