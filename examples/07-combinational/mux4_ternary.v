// 4 选 1 多路选择器：条件操作符链写法（与 case 写法等价）
module mux4_ternary (
    input  wire [1:0] sel,
    input  wire [3:0] din,
    output wire       dout
);
    assign dout = (sel == 2'd0) ? din[0] :
                  (sel == 2'd1) ? din[1] :
                  (sel == 2'd2) ? din[2] :
                                  din[3];
endmodule
