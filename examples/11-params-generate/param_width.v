// 参数化位宽模块：位宽由 parameter 决定，默认 8 位
module param_width #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0] din,
    output wire [WIDTH-1:0] dout
);
    localparam SHIFT = 1;   // 内部常量：不可被外部重载

    assign dout = {din[0], din[WIDTH-1:1]};   // 循环右移 SHIFT 位
endmodule
