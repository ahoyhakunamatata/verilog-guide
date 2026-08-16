// gen_for_parity 自检测试台
`timescale 1ns/1ps
module gen_for_parity_tb;
    reg  [7:0] din;
    wire       parity;

    gen_for_parity u_dut (.din(din), .parity(parity));

    initial begin
        din = 8'b1010_1010; #10;   // 4 个 1
        if (parity !== 1'b0) $display("FAIL even=%b", parity);
        din = 8'b1010_1011; #10;   // 5 个 1
        if (parity !== 1'b1) $display("FAIL odd=%b", parity);
        din = 8'hFF; #10;          // 8 个 1
        if (parity !== 1'b0) $display("FAIL eight=%b", parity);
        $display("PASS");
        $finish;
    end
endmodule
