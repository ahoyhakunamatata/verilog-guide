// 4-2 优先编码器：if-else 链表达优先级（高位数优先）
module priority_encoder (
    input  wire [3:0] din,
    output reg  [1:0] code,
    output reg        valid
);
    always @(*) begin
        if (din[3]) begin
            code  = 2'd3;
            valid = 1'b1;
        end else if (din[2]) begin
            code  = 2'd2;
            valid = 1'b1;
        end else if (din[1]) begin
            code  = 2'd1;
            valid = 1'b1;
        end else if (din[0]) begin
            code  = 2'd0;
            valid = 1'b1;
        end else begin
            code  = 2'd0;
            valid = 1'b0;
        end
    end
endmodule
