// comparator4 自检测试台
`timescale 1ns/1ps
module comparator4_tb;
    reg  [3:0] a, b;
    wire       a_gt_b, a_eq_b, a_lt_b;

    comparator4 u_dut (.a(a), .b(b), .a_gt_b(a_gt_b), .a_eq_b(a_eq_b), .a_lt_b(a_lt_b));

    initial begin
        a = 4'd5;  b = 4'd3; #10;
        if ({a_gt_b, a_eq_b, a_lt_b} !== 3'b100) $display("FAIL gt");
        a = 4'd3;  b = 4'd5; #10;
        if ({a_gt_b, a_eq_b, a_lt_b} !== 3'b001) $display("FAIL lt");
        a = 4'd7;  b = 4'd7; #10;
        if ({a_gt_b, a_eq_b, a_lt_b} !== 3'b010) $display("FAIL eq");
        $display("PASS");
        $finish;
    end
endmodule
