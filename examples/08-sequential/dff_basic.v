// 基本 D 触发器模板：非阻塞赋值 + 时钟沿敏感列表
module dff_basic (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(posedge clk)
        q <= d;
endmodule
