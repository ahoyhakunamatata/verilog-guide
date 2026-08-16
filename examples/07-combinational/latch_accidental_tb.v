// latch_accidental 自检测试台：验证锁存器的"记忆"行为
`timescale 1ns/1ps
module latch_accidental_tb;
    reg  [3:0] din;
    reg        en;
    wire [3:0] q_latched, q_gated;

    latch_accidental u_dut (.din(din), .en(en),
                            .q_latched(q_latched), .q_gated(q_gated));

    initial begin
        en = 1'b1; din = 4'hA; #10;
        if (q_latched !== 4'hA) $display("FAIL latch load=%h", q_latched);
        if (q_gated   !== 4'hA) $display("FAIL gated load=%h", q_gated);

        en = 1'b0; din = 4'hB; #10;
        if (q_latched !== 4'hA) $display("FAIL latch should hold=%h", q_latched);
        if (q_gated   !== 4'h0) $display("FAIL gated should be 0=%h", q_gated);

        en = 1'b1; #10;   // din 仍为 B：重新打开后锁存器跟随新值
        if (q_latched !== 4'hB) $display("FAIL latch reopen=%h", q_latched);
        $display("PASS");
        $finish;
    end
endmodule
