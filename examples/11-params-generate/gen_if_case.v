// generate if：按参数选择不同结构（elaboration 期决定，非运行时）
module gen_if_case #(
    parameter MODE = 0     // 0：直通；1：按位取反；其他：加一
) (
    input  wire [7:0] din,
    output wire [7:0] dout
);
    generate
        if (MODE == 0)
            assign dout = din;
        else if (MODE == 1)
            assign dout = ~din;
        else
            assign dout = din + 8'd1;
    endgenerate
endmodule
