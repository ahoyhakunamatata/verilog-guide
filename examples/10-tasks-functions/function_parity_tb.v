// function_parity 自检测试台
`timescale 1ns/1ps
module function_parity_tb;
    reg  [7:0] din;
    wire       parity;

    function_parity u_dut (.din(din), .parity(parity));

    initial begin
        din = 8'b1010_1010; #10;   // 4 个 1：偶校验
        if (parity !== 1'b0) $display("FAIL even=%b", parity);
        din = 8'b1010_1011; #10;   // 5 个 1：奇校验
        if (parity !== 1'b1) $display("FAIL odd=%b", parity);
        din = 8'h00; #10;
        if (parity !== 1'b0) $display("FAIL zero=%b", parity);
        $display("PASS");
        $finish;
    end
endmodule
