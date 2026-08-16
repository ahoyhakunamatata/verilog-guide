// 演示用被测模块：4 位加法器（任务激励演示的 DUT）
module task_stimulus (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [4:0] sum
);
    assign sum = {1'b0, a} + {1'b0, b};
endmodule
