// 可变域选（Verilog-2001）：[base +: width] 或 [base -: width]
// base 可以是变量；相比常量边界域选 data[msb:lsb]，它保证选择宽度恒定
module part_select (
    input  wire [1:0] index,   // 0 ~ 3
    input  wire [7:0] data,
    output wire [1:0] pair     // 取 index 指定的 2 位组（小端）
);
    assign pair = data[index*2 +: 2];   // 等价于 data[index*2+1 : index*2]
endmodule
