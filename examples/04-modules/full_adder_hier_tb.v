// full_adder_hier 自检测试台：遍历 8 种输入组合
`timescale 1ns/1ps
module full_adder_hier_tb;
    reg  a, b, cin;
    wire sum, cout;

    full_adder_hier u_dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    integer i;
    reg [1:0] expected;

    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i[2:0];
            #10;
            expected = a + b + cin;   // 2 位和：{cout, sum}
            if ({cout, sum} !== expected) $display("FAIL i=%0d got=%b", i, {cout, sum});
        end
        $display("PASS");
        $finish;
    end
endmodule
