// 移位、拼接与重复拼接
module shift_concat (
    input  wire [3:0] a,
    output wire [7:0] shl,     // 逻辑左移：右侧补 0
    output wire [7:0] shr,     // 逻辑右移：左侧补 0
    output wire [7:0] concat,  // 拼接
    output wire [7:0] replic   // 重复拼接
);
    assign shl    = a << 2;          // 8 位上下文：左移 2 位
    assign shr    = a >> 2;
    assign concat = {a, 4'b0000};    // 拼接：各段位宽可不同
    assign replic = {2{a}};          // 重复拼接：等价 {a, a}
endmodule
