// 算术操作符：+ - * / % **（** 为 2001 新增的幂运算）
module arithmetic (
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [8:0]  sum,       // 9 位 LHS：加法在 9 位上下文求值，进位保留
    output wire [7:0]  diff,
    output wire [15:0] product,   // 乘法结果位宽 = 两操作数位宽之和
    output wire [7:0]  quotient,
    output wire [7:0]  remainder,
    output wire [15:0] square
);
    assign sum       = a + b;
    assign diff      = a - b;
    assign product   = a * b;
    assign quotient  = a / b;     // 整数除法：截断小数
    assign remainder = a % b;     // 取模：与除法的符号规则一致
    assign square    = a ** 2;    // 幂运算
endmodule
