// half_adder_gates 自检测试台
`timescale 1ns/1ps
module half_adder_gates_tb;
    reg  a, b;
    wire sum, carry;

    half_adder_gates u_dut (.a(a), .b(b), .sum(sum), .carry(carry));

    initial begin
        {a, b} = 2'b00; #10;
        if ({carry, sum} !== 2'b00) $display("FAIL 00");
        {a, b} = 2'b01; #10;
        if ({carry, sum} !== 2'b01) $display("FAIL 01");
        {a, b} = 2'b10; #10;
        if ({carry, sum} !== 2'b01) $display("FAIL 10");
        {a, b} = 2'b11; #10;
        if ({carry, sum} !== 2'b10) $display("FAIL 11");
        $display("PASS");
        $finish;
    end
endmodule
