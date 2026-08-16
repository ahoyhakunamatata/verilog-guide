// 位操作与逻辑操作的区别
module logical_bitwise (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [3:0] bw_and,   // 按位与：结果仍是 4 位向量
    output wire [3:0] bw_or,
    output wire [3:0] bw_xor,
    output wire [3:0] bw_not,
    output wire       lg_and,   // 逻辑与：结果恒为 1 位
    output wire       lg_or,
    output wire       lg_not
);
    assign bw_and = a & b;
    assign bw_or  = a | b;
    assign bw_xor = a ^ b;
    assign bw_not = ~a;

    assign lg_and = a && b;     // 非零即真：任意位为 1 即视为真
    assign lg_or  = a || b;
    assign lg_not = !a;         // 只有全 0 时 !a 才为 1
endmodule
