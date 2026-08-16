// 3-8 译码器：case 描述（推荐），带使能
module decoder38 (
    input  wire [2:0] sel,
    input  wire       en,
    output reg  [7:0] y
);
    always @(*) begin
        if (!en)
            y = 8'h00;
        else
            case (sel)
                3'd0:    y = 8'b0000_0001;
                3'd1:    y = 8'b0000_0010;
                3'd2:    y = 8'b0000_0100;
                3'd3:    y = 8'b0000_1000;
                3'd4:    y = 8'b0001_0000;
                3'd5:    y = 8'b0010_0000;
                3'd6:    y = 8'b0100_0000;
                default: y = 8'b1000_0000;
            endcase
    end
endmodule
