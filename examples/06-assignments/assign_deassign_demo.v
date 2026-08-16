// 过程连续赋值 assign/deassign 演示对象：普通 always 驱动 q 跟随 din
module assign_deassign_demo (
    input  wire [3:0] din,
    output reg  [3:0] q
);
    always @(*) begin
        q = din;
    end
endmodule
