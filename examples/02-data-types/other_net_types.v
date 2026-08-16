// 其他网络类型：wand 线与、wor 线或、tri0/tri1 内建弱下拉/弱上拉
module other_net_types (
    input  wire a,
    input  wire b,
    output wand wand_out,   // 多驱动时按"线与"解析（等价 a & b）
    output wor  wor_out,    // 多驱动时按"线或"解析（等价 a | b）
    output tri0 tri0_out,   // 所有驱动为 z 时解析为 0（弱下拉）
    output tri1 tri1_out    // 所有驱动为 z 时解析为 1（弱上拉）
);
    assign wand_out = a;
    assign wand_out = b;    // 两个驱动同时作用于 wand：结果为 a & b

    assign wor_out = a;
    assign wor_out = b;     // 两个驱动同时作用于 wor：结果为 a | b

    assign tri0_out = 1'bz; // 驱动为 z，tri0 的弱下拉将网络解析为 0
    assign tri1_out = 1'bz; // 驱动为 z，tri1 的弱上拉将网络解析为 1
endmodule
