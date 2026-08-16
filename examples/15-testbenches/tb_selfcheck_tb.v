// 自检设计（自包含）：本指南 PASS/FAIL 约定的完整范式
`timescale 1ns/1ps
module tb_selfcheck_tb;
    // 被测：2 位计数器
    reg        clk, rst_n;
    reg  [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 2'd0;
        else
            cnt <= cnt + 1'b1;
    end

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    integer i;
    integer n_errors;   // 错误计数：便于汇总判定

    initial begin
        n_errors = 0;
        clk = 0; rst_n = 0;
        tick; #1;
        if (cnt !== 2'd0) begin
            $display("FAIL reset cnt=%b", cnt);
            n_errors = n_errors + 1;
        end
        rst_n = 1;
        for (i = 0; i < 8; i = i + 1) begin
            tick; #1;
            if (cnt !== ((i + 1) % 4)) begin
                $display("FAIL i=%0d cnt=%b", i, cnt);
                n_errors = n_errors + 1;
            end
        end
        // 汇总判定：有错即 FAIL（行首 FAIL 会被验证脚本捕获）
        if (n_errors != 0) $display("FAIL total_errors=%0d", n_errors);
        else               $display("PASS");
        $finish;
    end
endmodule
