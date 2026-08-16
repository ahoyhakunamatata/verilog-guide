// 序列检测器 1101：one-hot 状态编码写法（与 fsm_moore_3stage 功能相同）
module fsm_onehot (
    input  wire clk,
    input  wire rst_n,
    input  wire din,
    output reg  detect
);
    localparam S0 = 5'b00001,
               S1 = 5'b00010,
               S2 = 5'b00100,
               S3 = 5'b01000,
               S4 = 5'b10000;

    reg [4:0] state;
    reg [4:0] state_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S0;
        else
            state <= state_next;
    end

    always @(*) begin
        state_next = S0;   // 默认回 S0：任何非法编码自动恢复（one-hot 有 27 种非法编码）
        case (state)
            S0:    state_next = din ? S1 : S0;
            S1:    state_next = din ? S2 : S0;
            S2:    state_next = din ? S2 : S3;
            S3:    state_next = din ? S4 : S0;
            S4:    state_next = din ? S2 : S0;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            detect <= 1'b0;
        else
            detect <= (state_next == S4);
    end
endmodule
