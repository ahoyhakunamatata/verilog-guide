// timescale_demo 自检测试台：按 1ns/1ps 时间轴验证脉冲时序
`timescale 1ns/1ps
module timescale_demo_tb;
    wire pulse;

    timescale_demo u_dut (.pulse(pulse));

    initial begin
        #5;
        if (pulse !== 1'b0) $display("FAIL t=5 pulse=%b", pulse);
        #10;   // t=15：10.5ns 处已置 1
        if (pulse !== 1'b1) $display("FAIL t=15 pulse=%b", pulse);
        #10;   // t=25：20.5ns 处已清零
        if (pulse !== 1'b0) $display("FAIL t=25 pulse=%b", pulse);
        $display("PASS");
        $finish;
    end
endmodule
