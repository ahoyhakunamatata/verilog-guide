// counter_bcd 自检测试台：验证 0-9 循环序列
`timescale 1ns/1ps
module counter_bcd_tb;
    reg        clk, rst_n;
    wire [3:0] count;

    counter_bcd u_dut (.clk(clk), .rst_n(rst_n), .count(count));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    integer i;
    initial begin
        clk = 0; rst_n = 0;
        tick; #1;
        if (count !== 4'd0) $display("FAIL reset=%0d", count);
        rst_n = 1;
        for (i = 0; i < 15; i = i + 1) begin
            tick; #1;
            // 复位释放后首个时钟沿即开始计数：期望为 (i+1)%10
            if (count !== ((i + 1) % 10)) $display("FAIL i=%0d count=%0d", i, count);
        end
        $display("PASS");
        $finish;
    end
endmodule
