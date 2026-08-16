// 条件编译：仿真/综合隔离、功能开关
`define ENABLE_FEATURE   // 定义开关：注释掉本行即切换到另一条路径

module ifdef_guard (
    input  wire [7:0] din,
    output wire [7:0] dout
);
    `ifdef ENABLE_FEATURE
        assign dout = din + 8'd1;   // 功能开启：加一
    `else
        assign dout = din;          // 功能关闭：直通
    `endif
endmodule
