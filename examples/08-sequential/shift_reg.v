// 4 位移位寄存器：串行输入，并行输出（串转并）
module shift_reg (
    input  wire clk,
    input  wire rst_n,
    input  wire sdi,        // 串行输入
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (!rst_n)
            q <= 4'b0;
        else
            q <= {q[2:0], sdi};   // 左移：新数据从最低位进入
    end
endmodule
