// 意外锁存推断演示：不完整的 if（缺 else）产生锁存器
module latch_accidental (
    input  wire [3:0] din,
    input  wire       en,
    output reg  [3:0] q_latched,   // 缺 else：en=0 时保持旧值 → 推断锁存器
    output reg  [3:0] q_gated      // 条件完整：纯组合逻辑
);
    always @(*) begin
        if (en)
            q_latched = din;       // en=0 时 q_latched 无赋值 → 保持（有记忆！）
    end

    always @(*) begin
        if (en)
            q_gated = din;
        else
            q_gated = 4'h0;
    end
endmodule
