// precedence 自检测试台
`timescale 1ns/1ps
module precedence_tb;
    reg  [3:0] a, b;
    wire [7:0] c_intuition, verilog_actual, with_paren;

    precedence u_dut (.a(a), .b(b), .c_intuition(c_intuition),
                      .verilog_actual(verilog_actual), .with_paren(with_paren));

    initial begin
        a = 4'd3; b = 4'd4; #10;
        if (c_intuition    !== 8'd11) $display("FAIL c_intuition=%0d", c_intuition);
        if (verilog_actual !== 8'd14) $display("FAIL verilog_actual=%0d", verilog_actual);
        if (with_paren     !== 8'd14) $display("FAIL with_paren=%0d", with_paren);
        $display("PASS");
        $finish;
    end
endmodule
