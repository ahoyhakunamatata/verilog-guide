// 数字字面量：位宽、基数、下划线、x/z、负数
module literals (
    output wire [7:0] bin_hex,   // 二进制与十六进制写法等价
    output wire [7:0] with_xz,   // 字面量中允许 x/z 位
    output wire [7:0] neg_value  // 负数：按二进制补码存为 8 位
);
    assign bin_hex   = 8'b1010_1010;  // 下划线仅分隔可读性，无其他含义
    assign with_xz   = 8'b10xz_01zz;
    assign neg_value = -8'd5;         // -5 的补码 = 8'hFB
endmodule
