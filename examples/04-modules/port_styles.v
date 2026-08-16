// 端口声明风格对比：ANSI 风格（2001，推荐）与旧式两段式风格
// 两个模块功能相同：4 位按位与
module port_styles_ansi (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output reg  [3:0] y      // ANSI：端口列表内一次声明类型与方向
);
    always @(*) y = a & b;
endmodule

// 旧式（Verilog-1995）：端口列表只列名字，再单独声明方向与类型
module port_styles_old (a, b, y);
    input  [3:0] a;
    input  [3:0] b;
    output [3:0] y;
    reg    [3:0] y;          // output 为 reg 类型时需要重复声明
    always @(*) y = a & b;
endmodule
