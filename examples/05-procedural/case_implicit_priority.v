// casez 的隐式优先级与 x/z 匹配陷阱
module case_implicit_priority (
    input  wire [1:0] sel,
    input  wire [1:0] din,
    output reg        y
);
    always @(*) begin
        casez (sel)          // z/? 位当作通配符
            2'b1?:  y = din[1];   // 匹配 10、11
            2'b?1:  y = din[0];   // 匹配 01、11
            default: y = 1'b0;
        endcase
    end
endmodule
