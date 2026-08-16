// 门级结构描述：半加器（xor 产生和，and 产生进位）
module half_adder_gates (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire carry
);
    xor (sum,   a, b);   // 门原语实例：输出在前，输入在后
    and (carry, a, b);
endmodule
