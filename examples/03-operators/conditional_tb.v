// conditional 自检测试台
`timescale 1ns/1ps
module conditional_tb;
    reg  [3:0] a, b, c;
    wire [3:0] max_ab, max_abc;

    conditional u_dut (.a(a), .b(b), .c(c), .max_ab(max_ab), .max_abc(max_abc));

    initial begin
        a = 4'd3;  b = 4'd9;  c = 4'd5;  #10;
        if (max_ab  !== 4'd9) $display("FAIL max_ab=%0d", max_ab);
        if (max_abc !== 4'd9) $display("FAIL max_abc=%0d", max_abc);
        a = 4'd10; b = 4'd2;  c = 4'd7;  #10;
        if (max_ab  !== 4'd10) $display("FAIL max_ab2=%0d", max_ab);
        if (max_abc !== 4'd10) $display("FAIL max_abc2=%0d", max_abc);
        a = 4'd1;  b = 4'd4;  c = 4'd6;  #10;
        if (max_ab  !== 4'd4) $display("FAIL max_ab3=%0d", max_ab);
        if (max_abc !== 4'd6) $display("FAIL max_abc3=%0d", max_abc);
        $display("PASS");
        $finish;
    end
endmodule
