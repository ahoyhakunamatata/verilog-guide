// UDP 用户自定义原语（仅仿真/单元库建模）：真值表描述 2 选 1 MUX
primitive udp_mux (y, sel, a, b);
    output y;
    input  sel, a, b;
    table
        // sel a b : y     ? 表示该项无关
            0 0 ? : 0;     // sel=0：选择 a
            0 1 ? : 1;
            1 ? 0 : 0;     // sel=1：选择 b
            1 ? 1 : 1;
            x 0 0 : 0;     // 可选的 x 处理行：两输入相同时结果确定
            x 1 1 : 1;
    endtable
endprimitive

`timescale 1ns/1ps
module udp_mux_tb;
    reg  sel, a, b;
    wire y;

    udp_mux u_mux (y, sel, a, b);   // 注意：UDP 例化是位置连接

    initial begin
        sel = 0; a = 0; b = 1; #10;
        if (y !== 1'b0) $display("FAIL sel=0 a=0");
        sel = 0; a = 1; b = 0; #10;
        if (y !== 1'b1) $display("FAIL sel=0 a=1");
        sel = 1; a = 0; b = 1; #10;
        if (y !== 1'b1) $display("FAIL sel=1 b=1");
        sel = 1; a = 1; b = 0; #10;
        if (y !== 1'b0) $display("FAIL sel=1 b=0");
        $display("PASS");
        $finish;
    end
endmodule
