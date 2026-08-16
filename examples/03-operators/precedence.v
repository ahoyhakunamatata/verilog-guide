// 操作符优先级陷阱：Verilog 中二元 + - 的优先级高于移位（与 C 语言相反）
module precedence (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [7:0] c_intuition,    // C 语言直觉的写法：a + (b<<1) = 11
    output wire [7:0] verilog_actual, // Verilog 实际求值：a + b << 1 = (a+b)<<1 = 14
    output wire [7:0] with_paren      // 显式括号：意图清晰，与 verilog_actual 同值
);
    assign c_intuition    = a + (b << 1);   // 3 + 8 = 11
    assign verilog_actual = a + b << 1;     // 标准规定 + 高于 <<：先加后移 = 14
    assign with_paren     = (a + b) << 1;   // 与 verilog_actual 等价，但意图明确
endmodule
