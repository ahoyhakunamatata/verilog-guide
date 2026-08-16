// 循环语句：for（可综合，边界必须静态确定）、while/repeat/forever（仿真为主）
module loops (
    input  wire [3:0] din,
    output reg  [3:0] rev,         // 位反转
    output reg  [3:0] count_ones   // 统计 1 的个数
);
    integer i;

    always @(*) begin
        rev = 4'b0;
        for (i = 0; i < 4; i = i + 1)
            rev[i] = din[3 - i];
    end

    always @(*) begin
        count_ones = 4'd0;
        for (i = 0; i < 4; i = i + 1)
            if (din[i])
                count_ones = count_ones + 1;
    end
endmodule
