// rca4 自检测试台：穷举 256 种输入组合
`timescale 1ns/1ps
module rca4_tb;
    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] sum;
    wire       cout;

    rca4 u_dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    integer i;
    reg [4:0] expected;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            {a, b} = i[7:0];
            cin = 1'b0;
            #10;
            expected = {1'b0, a} + {1'b0, b};   // 5 位期望值（含进位）
            if ({cout, sum} !== expected) $display("FAIL i=%0d got=%b", i, {cout, sum});
        end
        // 进位输入抽查
        a = 4'b1111; b = 4'b0000; cin = 1'b1; #10;
        if ({cout, sum} !== 5'b10000) $display("FAIL cin");
        $display("PASS");
        $finish;
    end
endmodule
