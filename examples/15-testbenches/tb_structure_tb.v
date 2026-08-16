// 测试台结构演示（自包含）：信号声明 / 被测例化 / 激励生成 / 自检 四部分
`timescale 1ns/1ps
module tb_structure_tb;
    // ---- 第一部分：信号声明 ----
    reg  [3:0] a, b;
    wire [4:0] sum;

    // ---- 第二部分：被测模块例化 ----
    adder u_dut (.a(a), .b(b), .sum(sum));

    // ---- 第三部分：激励生成（独立过程块）----
    initial begin
        a = 0; b = 0;
        repeat (10) begin
            #10;
            a = a + 1'b1;
            b = b + 4'd3;
        end
    end

    // ---- 第四部分：自检（独立过程块，与参考模型实时比对）----
    always @(a or b) begin
        #1;   // 组合逻辑稳定后比对
        if (sum !== {1'b0, a} + {1'b0, b})
            $display("FAIL a=%0d b=%0d sum=%0d", a, b, sum);
    end

    // ---- 结束控制 ----
    initial begin
        #130;
        $display("PASS");
        $finish;
    end
endmodule

module adder (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [4:0] sum
);
    assign sum = {1'b0, a} + {1'b0, b};
endmodule
