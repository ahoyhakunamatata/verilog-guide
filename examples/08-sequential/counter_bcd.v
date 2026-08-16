// BCD 计数器：0-9 循环，带同步复位
module counter_bcd (
    input  wire clk,
    input  wire rst_n,
    output reg  [3:0] count
);
    always @(posedge clk) begin
        if (!rst_n)
            count <= 4'd0;
        else if (count == 4'd9)
            count <= 4'd0;
        else
            count <= count + 1'b1;
    end
endmodule
