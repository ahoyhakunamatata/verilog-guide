// generate for：级联异或树计算 8 位奇偶校验
module gen_for_parity (
    input  wire [7:0] din,
    output wire       parity
);
    wire [8:0] chain;
    assign chain[0] = 1'b0;
    assign parity   = chain[8];

    genvar i;   // genvar：只能在 generate for 中使用
    generate
        for (i = 0; i < 8; i = i + 1) begin : xor_stage   // 命名块生成层次路径
            xor2 u_x (.a(din[i]), .b(chain[i]), .y(chain[i+1]));
        end
    endgenerate
endmodule

module xor2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a ^ b;
endmodule
