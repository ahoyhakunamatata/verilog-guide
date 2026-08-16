// if-else 链与 case 的行为描述对比
module if_case (
    input  wire [1:0] sel,
    input  wire [3:0] din,
    output reg        y_if,     // if-else 链：条件依次判断，隐含优先级
    output reg        y_case    // case：项之间是并行关系（互斥语义由 default 保证完整）
);
    always @(*) begin
        if (sel == 2'd0)
            y_if = din[0];
        else if (sel == 2'd1)
            y_if = din[1];
        else if (sel == 2'd2)
            y_if = din[2];
        else
            y_if = din[3];
    end

    always @(*) begin
        case (sel)
            2'd0:    y_case = din[0];
            2'd1:    y_case = din[1];
            2'd2:    y_case = din[2];
            default: y_case = din[3];
        endcase
    end
endmodule
