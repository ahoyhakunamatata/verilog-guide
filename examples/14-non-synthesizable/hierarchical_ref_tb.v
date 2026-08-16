// 层次引用（仅仿真）：TB 用层次路径直接观察 DUT 内部信号
`timescale 1ns/1ps
module hierarchical_ref_tb;
    reg  [1:0] a, b;
    wire [2:0] sum;

    adder_dut u_dut (.a(a), .b(b), .sum(sum));

    initial begin
        a = 2'd3; b = 2'd3;   // 位 0 相加 1+1=2：产生进位 carry0=1
        #10;
        // 层次路径 u_dut.carry0：访问模块内部未引出的进位信号
        if (u_dut.carry0 !== 1'b1) $display("FAIL internal carry=%b", u_dut.carry0);
        if (sum !== 3'd6)          $display("FAIL sum=%0d", sum);
        $display("PASS");
        $finish;
    end
endmodule

// 被测模块：内部进位 carry0 没有引出端口，仅能通过层次引用观察
module adder_dut (
    input  wire [1:0] a,
    input  wire [1:0] b,
    output wire [2:0] sum
);
    wire carry0;

    assign {carry0, sum[0]} = a[0] + b[0];
    assign sum[2:1]         = a[1] + b[1] + carry0;
endmodule
