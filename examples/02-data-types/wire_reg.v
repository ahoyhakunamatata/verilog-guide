// wire 与 reg 的本质区别：wire 表示连线（由驱动决定），reg 表示过程赋值的存放目标
module wire_reg (
    input  wire a,
    input  wire b,
    output wire w_and,     // wire：只能用连续赋值（或例化连接）驱动
    output reg  r_and      // reg：只能在过程块（always/initial）中赋值
);
    assign w_and = a & b;  // 连续赋值驱动 wire

    always @(*) begin
        r_and = a & b;     // 过程赋值写入 reg
    end
endmodule
