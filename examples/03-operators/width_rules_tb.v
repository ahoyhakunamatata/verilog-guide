// width_rules 自检测试台
`timescale 1ns/1ps
module width_rules_tb;
    reg  [3:0] a, b;
    wire [4:0] sum_ok;
    wire [7:0] sum_ext, with_const;
    wire [3:0] sum_trunc;

    width_rules u_dut (.a(a), .b(b), .sum_ok(sum_ok), .sum_ext(sum_ext),
                       .sum_trunc(sum_trunc), .with_const(with_const));

    initial begin
        a = 4'b1111; b = 4'b0001; #10;
        if (sum_ok     !== 5'b10000) $display("FAIL sum_ok=%b", sum_ok);
        if (sum_ext    !== 8'h10)    $display("FAIL sum_ext=%h", sum_ext);
        if (sum_trunc  !== 4'b0000)  $display("FAIL sum_trunc=%b", sum_trunc);
        if (with_const !== 8'h11)    $display("FAIL with_const=%h", with_const);

        a = 4'b1010; b = 4'b0101; #10;
        if (sum_ok    !== 5'b01111) $display("FAIL sum_ok2=%b", sum_ok);
        if (sum_trunc !== 4'b1111)  $display("FAIL sum_trunc2=%b", sum_trunc);
        $display("PASS");
        $finish;
    end
endmodule
