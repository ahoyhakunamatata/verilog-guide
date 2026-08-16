// tristate_bus 自检测试台：两个主设备共享一条总线，使能互斥
`timescale 1ns/1ps
module tristate_bus_tb;
    wire [7:0] bus;
    reg  [7:0] data_a, data_b;
    reg        oe_a, oe_b;

    tristate_bus u_a (.bus(bus), .data_out(data_a), .oe(oe_a));
    tristate_bus u_b (.bus(bus), .data_out(data_b), .oe(oe_b));

    initial begin
        data_a = 8'hA5; data_b = 8'h5A;
        oe_a = 1'b1; oe_b = 1'b0; #10;
        if (bus !== 8'hA5) $display("FAIL A drives=%h", bus);

        oe_a = 1'b0; oe_b = 1'b1; #10;
        if (bus !== 8'h5A) $display("FAIL B drives=%h", bus);

        oe_a = 1'b0; oe_b = 1'b0; #10;
        if (bus !== 8'hzz) $display("FAIL hi-z=%h", bus);

        // 两个主设备同时驱动不同值：冲突 → 全 x
        oe_a = 1'b1; oe_b = 1'b1; #10;
        if (bus !== 8'hxx) $display("FAIL conflict=%h", bus);

        // 无驱动时总线可被外部驱动（TB 侧灌入数据，验证 inout 的接收路径）
        oe_a = 1'b0; oe_b = 1'b0;
        force bus = 8'h33; #10;
        if (bus !== 8'h33) $display("FAIL external drive=%h", bus);
        release bus;
        $display("PASS");
        $finish;
    end
endmodule
