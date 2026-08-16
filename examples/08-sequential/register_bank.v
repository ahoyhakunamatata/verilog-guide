// 寄存器组：4 个 8 位寄存器，地址译码写入
module register_bank (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       we,
    input  wire [1:0] addr,
    input  wire [7:0] wdata,
    output reg  [7:0] q0,
    output reg  [7:0] q1,
    output reg  [7:0] q2,
    output reg  [7:0] q3
);
    always @(posedge clk) begin
        if (!rst_n) begin
            q0 <= 8'h0; q1 <= 8'h0; q2 <= 8'h0; q3 <= 8'h0;
        end else if (we) begin
            case (addr)
                2'd0:    q0 <= wdata;
                2'd1:    q1 <= wdata;
                2'd2:    q2 <= wdata;
                default: q3 <= wdata;
            endcase
        end
    end
endmodule
