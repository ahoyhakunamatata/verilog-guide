// specify 块与时序检查（仅仿真/标准单元建模）：$setup 违例报告
`timescale 1ns/1ps
module timing_checks_tb;
    reg  clk, d;
    wire q;

    dff_spec u_dut (.clk(clk), .d(d), .q(q));

    initial begin
        clk = 0; d = 0;
        #10 d = 1;    // t=10：d 稳定
        #10 clk = 1;  // t=20 边沿：setup 时间 10ns > 3ns 要求，合法
        #1;
        if (q !== 1'b1) $display("FAIL q=%b", q);
        #9 clk = 0;   // t=30
        d = 0;
        #8 d = 1;     // t=38：d 变化
        #2 clk = 1;   // t=40 边沿：setup 仅 2ns < 3ns → 仿真器将报告 TIMING ERROR
        #10;          // 违例只报告不中断仿真，功能检查仍可继续
        if (q !== 1'b1) $display("FAIL q2=%b", q);
        $display("PASS");
        $finish;
    end
endmodule

// 带 specify 时序检查的 D 触发器模型
module dff_spec (
    input  wire clk,
    input  wire d,
    output reg  q
);
    always @(posedge clk)
        q <= d;

    specify
        specparam t_setup = 3;   // setup 时间要求 3ns
        $setup(d, posedge clk, t_setup);
    endspecify
endmodule
