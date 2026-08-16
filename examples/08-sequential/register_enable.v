// 带时钟使能的寄存器：en=1 才更新（等价"寄存器+数据选择"的节能结构）
module register_enable (
    input  wire [7:0] din,
    input  wire       en,
    input  wire       clk,
    input  wire       rst_n,
    output reg  [7:0] q
);
    always @(posedge clk) begin
        if (!rst_n)
            q <= 8'h0;
        else if (en)
            q <= din;
    end
endmodule
