// `define 宏：常量与带参宏
`define DATA_W 8
`define ADD(a, b) ((a) + (b))   // 带参宏：参数加括号防止展开后优先级错乱

module define_macro (
    input  wire [`DATA_W-1:0] a,
    input  wire [`DATA_W-1:0] b,
    output wire [`DATA_W-1:0] sum
);
    // 宏展开：assign sum = ((a) + (b));
    assign sum = `ADD(a, b);
endmodule
