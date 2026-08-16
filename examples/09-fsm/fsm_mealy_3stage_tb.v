// fsm_mealy_3stage 自检测试台：输入序列 1101101，应在第 4、7 位完成检测
`timescale 1ns/1ps
module fsm_mealy_3stage_tb;
    reg  clk, rst_n, din;
    wire detect;

    fsm_mealy_3stage u_dut (.clk(clk), .rst_n(rst_n), .din(din), .detect(detect));

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
            din = seq[7 - k];
            #3;   // 时钟沿前检查：Mealy 组合输出随 din 与当前状态立即有效
            if (detect !== ((k == 3) || (k == 6))) $display("FAIL k=%0d detect=%b", k, detect);
            #2; tick; #1;   // 完成本拍（tick 在 +5 处产生上升沿）
        end
        $display("PASS");
        $finish;
    end
endmodule
