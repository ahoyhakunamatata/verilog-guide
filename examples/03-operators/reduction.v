// 缩减操作符（一元）：对整个向量做折叠运算，结果为 1 位
module reduction (
    input  wire [3:0] a,
    output wire       all_ones,  // &a ：所有位为 1 才为 1
    output wire       any_one,   // |a ：任一位置 1 即为 1
    output wire       parity,    // ^a ：1 的个数为奇数时为 1
    output wire       nand_all,  // ~&a
    output wire       nor_all,   // ~|a
    output wire       xnor_all   // ~^a：等价于偶校验
);
    assign all_ones = &a;
    assign any_one  = |a;
    assign parity   = ^a;
    assign nand_all = ~&a;
    assign nor_all  = ~|a;
    assign xnor_all = ~^a;
endmodule
