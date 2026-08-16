// 函数：奇偶校验计算（可综合——函数是组合逻辑的封装）
module function_parity (
    input  wire [7:0] din,
    output wire       parity
);
    function calc_parity;
        input [7:0] data;      // 函数输入（2001 起可写 ANSI 风格端口列表）
        integer i;
        begin
            calc_parity = 1'b0;   // 函数名即返回变量：至少赋值一次
            for (i = 0; i < 8; i = i + 1)
                calc_parity = calc_parity ^ data[i];
        end
    endfunction

    assign parity = calc_parity(din);
endmodule
