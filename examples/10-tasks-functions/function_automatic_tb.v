// function_automatic 自检测试台
`timescale 1ns/1ps
module function_automatic_tb;
    reg  [3:0]  n;
    wire [31:0] fact;

    function_automatic u_dut (.n(n), .fact(fact));

    initial begin
        n = 4'd5; #10;
        if (fact !== 32'd120) $display("FAIL 5!=%0d", fact);
        n = 4'd0; #10;
        if (fact !== 32'd1) $display("FAIL 0!=%0d", fact);
        n = 4'd8; #10;
        if (fact !== 32'd40320) $display("FAIL 8!=%0d", fact);
        $display("PASS");
        $finish;
    end
endmodule
