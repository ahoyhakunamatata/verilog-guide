// 4 选 1 多路选择器：case 写法（推荐）
module mux4_case (
    input  wire [1:0] sel,
    input  wire [3:0] din,
    output reg        dout
);
    always @(*) begin
        case (sel)
            2'd0:    dout = din[0];
            2'd1:    dout = din[1];
            2'd2:    dout = din[2];
            default: dout = din[3];
        endcase
    end
endmodule
