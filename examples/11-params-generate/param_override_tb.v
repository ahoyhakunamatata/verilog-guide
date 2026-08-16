// param_override 自检测试台：两个计数器分别按 MAX=10 / MAX=5 循环
`timescale 1ns/1ps
module param_override_tb;
    reg        clk, rst_n;
    wire [3:0] cnt10;
    wire [2:0] cnt5;

    param_override u_dut (.clk(clk), .rst_n(rst_n), .cnt10(cnt10), .cnt5(cnt5));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    integer i;
    initial begin
        clk = 0; rst_n = 0;
        tick; #1;
        rst_n = 1;
        for (i = 0; i < 20; i = i + 1) begin
            tick; #1;
            if (cnt10 !== ((i + 1) % 10)) $display("FAIL i=%0d cnt10=%0d", i, cnt10);
            if (cnt5  !== ((i + 1) % 5))  $display("FAIL i=%0d cnt5=%0d", i, cnt5);
        end
        $display("PASS");
        $finish;
    end
endmodule
