// 条件操作符 ?:：二选一与嵌套三选一
module conditional (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [3:0] c,
    output wire [3:0] max_ab,   // 两数最大值
    output wire [3:0] max_abc   // 三数最大值（嵌套）
);
    assign max_ab = (a > b) ? a : b;

    assign max_abc = (a > b) ? ((a > c) ? a : c) :   // ?: 右结合，嵌套要加括号表意
                              ((b > c) ? b : c);
endmodule
