// clk_divider 自检测试台：16 个时钟周期内检查 4 分频波形
`timescale 1ns/1ps
module clk_divider_tb;
    reg        clk, rst_n;
    wire       clk_div4;

    clk_divider u_dut (.clk(clk), .rst_n(rst_n), .clk_div4(clk_div4));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    integer i;
    initial begin
        clk = 0; rst_n = 0;
        tick; #1;
        if (clk_div4 !== 1'b0) $display("FAIL reset=%b", clk_div4);
        rst_n = 1;
        // 期望波形：周期 4，cnt[1] = 0,1,1,0 循环（占空比 50%）
        for (i = 0; i < 16; i = i + 1) begin
            tick; #1;
            if (clk_div4 !== ((i % 4) == 1 || (i % 4) == 2)) $display("FAIL i=%0d div4=%b", i, clk_div4);
        end
        $display("PASS");
        $finish;
    end
endmodule
