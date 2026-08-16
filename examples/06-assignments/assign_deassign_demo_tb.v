// assign/deassign 语义演示（仅仿真）：对 DUT 内部 reg 做过程连续赋值
`timescale 1ns/1ps
module assign_deassign_demo_tb;
    reg  [3:0] din;
    wire [3:0] q;

    assign_deassign_demo u_dut (.din(din), .q(q));

    initial begin
        din = 4'hA; #10;   // 正常：always 驱动 q 跟随 din
        if (u_dut.q !== 4'hA) $display("FAIL normal=%h", u_dut.q);

        assign u_dut.q = 4'hF; #10;   // 过程连续赋值接管：q 恒为 F
        if (u_dut.q !== 4'hF) $display("FAIL assign=%h", u_dut.q);

        din = 4'hB; #10;   // din 变化，但 assign 期间 q 仍被按住
        if (u_dut.q !== 4'hF) $display("FAIL hold=%h", u_dut.q);

        deassign u_dut.q; #10;   // 释放：q 保持 F，直到下一次过程赋值
        if (u_dut.q !== 4'hF) $display("FAIL deassign=%h", u_dut.q);

        din = 4'hC; #10;   // din 变化触发 always，恢复常规驱动
        if (u_dut.q !== 4'hC) $display("FAIL restore=%h", u_dut.q);
        $display("PASS");
        $finish;
    end
endmodule
