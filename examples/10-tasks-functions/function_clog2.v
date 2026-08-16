// 函数：ceil(log2) 计算——地址位宽参数化的常用工具（可综合）
// 注意：IEEE 1364-2005 没有 $clog2（SystemVerilog 才有），这里用纯 Verilog 实现
module function_clog2 #(
    parameter WIDTH = 16
) (
    input  wire [WIDTH-1:0] din,
    output wire [3:0]       addr_width
);
    // 计算表示 din 所需的最小位宽
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = 0; 2 ** i < value; i = i + 1)
                clog2 = i + 1;
        end
    endfunction

    localparam AW = clog2(WIDTH);

    assign addr_width = AW[3:0];
endmodule
