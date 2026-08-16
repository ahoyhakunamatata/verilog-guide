// 序列检测器 1101（支持重叠检测）：Moore 型，三段式推荐写法
module fsm_moore_3stage (
    input  wire clk,
    input  wire rst_n,
    input  wire din,
    output reg  detect   // Moore：输出只与状态有关（寄存器输出，无毛刺）
);
    // ---- 第一段：状态定义 ----
    localparam S0 = 3'd0,   // 复位状态
               S1 = 3'd1,   // 已匹配 "1"
               S2 = 3'd2,   // 已匹配 "11"
               S3 = 3'd3,   // 已匹配 "110"
               S4 = 3'd4;   // 已匹配 "1101"

    reg [2:0] state;
    reg [2:0] state_next;

    // ---- 第二段：时序逻辑——状态寄存器 ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S0;
        else
            state <= state_next;
    end

    // ---- 第三段：组合逻辑——次态计算（一表看懂全部转移）----
    always @(*) begin
        state_next = state;
        case (state)
            S0:    if (din) state_next = S1; else state_next = S0;
            S1:    if (din) state_next = S2; else state_next = S0;
            S2:    if (din) state_next = S2; else state_next = S3;
            S3:    if (din) state_next = S4; else state_next = S0;
            // 重叠检测关键：完成 "1101" 后，结尾的 "11" 是新序列的合法前缀
            S4:    if (din) state_next = S2; else state_next = S0;
            default: state_next = S0;   // 非法状态恢复
        endcase
    end

    // ---- 输出寄存器：detect 与状态同步一拍（干净的寄存器输出）----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            detect <= 1'b0;
        else
            detect <= (state_next == S4);
    end
endmodule
