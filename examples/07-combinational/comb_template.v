// 组合逻辑的两种等价模板：always @(*) 与连续赋值
module comb_template (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       sel,
    output reg  [3:0] y_always,   // always @(*) + case
    output wire [3:0] y_assign    // assign + 条件操作符
);
    always @(*) begin
        case (sel)
            1'b0:    y_always = a;
            default: y_always = b;
        endcase
    end

    assign y_assign = sel ? b : a;
endmodule
