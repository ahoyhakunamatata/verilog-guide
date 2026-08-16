// 向量的位选与域选
module vector_select (
    input  wire [7:0] data,
    output wire       lsb,          // 位选：data[0]
    output wire       msb,          // 位选：data[7]
    output wire [3:0] low_nibble,   // 域选：data[3:0]
    output wire [3:0] high_nibble   // 域选：data[7:4]
);
    assign lsb         = data[0];
    assign msb         = data[7];
    assign low_nibble  = data[3:0];   // 域选边界必须是常量表达式
    assign high_nibble = data[7:4];
endmodule
