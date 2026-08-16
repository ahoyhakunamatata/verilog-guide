// 一段式 vs 三段式对比：同一 1101 检测器两种写法，行为完全一致
module fsm_style_compare (
    input  wire clk,
    input  wire rst_n,
    input  wire din,
    output reg  detect_1stage,
    output reg  detect_3stage
);
    localparam S0 = 2'd0, S1 = 2'd1, S2 = 2'd2, S3 = 2'd3;

    // ---- 一段式：状态转移与输出混合在同一个时序块（状态少时勉强可读）----
    reg [1:0] st1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            st1 <= S0;
            detect_1stage <= 1'b0;
        end else begin
            case (st1)
                S0: begin
                    st1 <= din ? S1 : S0;
                    detect_1stage <= 1'b0;
                end
                S1: begin
                    st1 <= din ? S2 : S0;
                    detect_1stage <= 1'b0;
                end
                S2: begin
                    st1 <= din ? S2 : S3;
                    detect_1stage <= 1'b0;
                end
                S3: begin
                    // 110+1 完成检测；结尾的 "1" 作为新序列前缀
                    if (din) begin
                        st1 <= S1;
                        detect_1stage <= 1'b1;
                    end else begin
                        st1 <= S0;
                        detect_1stage <= 1'b0;
                    end
                end
                default: begin
                    st1 <= S0;
                    detect_1stage <= 1'b0;
                end
            endcase
        end
    end

    // ---- 三段式：状态寄存器 / 次态组合逻辑 / 输出（推荐）----
    reg [1:0] state;
    reg [1:0] state_next;

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
            S3:    if (din) state_next = S1; else state_next = S0;
            default: state_next = S0;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            detect_3stage <= 1'b0;
        else
            detect_3stage <= (state == S3) && din;
    end
endmodule
