// 三态总线：inout 端口 + 输出使能
module tristate_bus (
    inout  wire [7:0] bus,
    input  wire [7:0] data_out,
    input  wire       oe        // 1：驱动总线；0：输出高阻（可接收）
);
    assign bus = oe ? data_out : 8'bz;
endmodule
