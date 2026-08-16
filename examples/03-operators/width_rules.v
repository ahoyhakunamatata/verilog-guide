// 表达式位宽规则：上下文决定（context-determined）与自我决定（self-determined）
module width_rules (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [4:0] sum_ok,     // 5 位 LHS：加法在 5 位上下文求值
    output wire [7:0] sum_ext,    // 8 位 LHS：加法在 8 位上下文求值
    output wire [3:0] sum_trunc,  // 4 位 LHS：与操作数同宽，进位丢失
    output wire [7:0] with_const  // 操作数含 8 位常量：上下文扩至 8 位
);
    assign sum_ok     = a + b;          // 4'b1111 + 4'b0001 = 5'b10000（进位保留）
    assign sum_ext    = a + b;          // 8 位上下文：结果 8'h10
    assign sum_trunc  = a + b;          // 4 位上下文：4'b0000（进位丢失！）
    assign with_const = a + 8'h2;       // 上下文 = max(8, 4, 8) = 8 位
endmodule
