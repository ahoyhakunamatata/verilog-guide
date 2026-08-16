// 序列检测器 1101（支持重叠检测）：Mealy 型三段式，输出组合
module fsm_mealy_3stage (
    input  wire clk,
    input  wire rst_n,
    input  wire din,
    output wire detect   // Mealy：输出与状态和输入都有关（组合输出，可能有毛刺）
);
    localparam S0 = 3'd0,   // 复位状态
               S1 = 3'd1,   // 已匹配 "1"
               S2 = 3'd2,   // 已匹配 "11"
               S3 = 3'd3;   // 已匹配 "110"（检测条件在此状态 + 输入 1）

    reg [2:0] state;
    reg [2:0] state_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S0;
        else
            state <= state_next;
    end

    always @(*) begin
        state_next = state;
        case (state)
            S0:    if (din) state_next = S1; else state_next = S0;
            S1:    if (din) state_next = S2; else state_next = S0;
            S2:    if (din) state_next = S2; else state_next = S3;
            // 完成检测（110+1），结尾的 "1" 同时作为新序列前缀
            S3:    if (din) state_next = S1; else state_next = S0;
            default: state_next = S0;
        endcase
    end

    // Mealy 输出：状态 S3 且输入 1 的当拍即有效（比 Moore 早半拍/一拍）
    assign detect = (state == S3) && din;
endmodule
