// priority_encoder 自检测试台
`timescale 1ns/1ps
module priority_encoder_tb;
    reg  [3:0] din;
    wire [1:0] code;
    wire       valid;

    priority_encoder u_dut (.din(din), .code(code), .valid(valid));

    initial begin
        din = 4'b1000; #10;
        if ({valid, code} !== 3'b111) $display("FAIL 1000");
        din = 4'b0101; #10;   // 最高位 din[2] 优先
        if ({valid, code} !== 3'b110) $display("FAIL 0101");
        din = 4'b0011; #10;
        if ({valid, code} !== 3'b101) $display("FAIL 0011");
        din = 4'b0001; #10;
        if ({valid, code} !== 3'b100) $display("FAIL 0001");
        din = 4'b0000; #10;
        if (valid !== 1'b0) $display("FAIL 0000");
        $display("PASS");
        $finish;
    end
endmodule
