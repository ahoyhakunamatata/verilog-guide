// wire_reg 自检测试台：遍历 4 种输入组合，w_and 与 r_and 必须一致
`timescale 1ns/1ps
module wire_reg_tb;
    reg  a, b;
    wire w_and, r_and;

    wire_reg u_dut (.a(a), .b(b), .w_and(w_and), .r_and(r_and));

    initial begin
        {a, b} = 2'b00; #10;
        if (w_and !== (a & b) || r_and !== (a & b)) $display("FAIL 00");
        {a, b} = 2'b01; #10;
        if (w_and !== (a & b) || r_and !== (a & b)) $display("FAIL 01");
        {a, b} = 2'b10; #10;
        if (w_and !== (a & b) || r_and !== (a & b)) $display("FAIL 10");
        {a, b} = 2'b11; #10;
        if (w_and !== (a & b) || r_and !== (a & b)) $display("FAIL 11");
        $display("PASS");
        $finish;
    end
endmodule
