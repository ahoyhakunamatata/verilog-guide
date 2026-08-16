// other_net_types 自检测试台
`timescale 1ns/1ps
module other_net_types_tb;
    reg  a, b;
    wire wand_out, wor_out, tri0_out, tri1_out;

    other_net_types u_dut (.a(a), .b(b), .wand_out(wand_out), .wor_out(wor_out),
                           .tri0_out(tri0_out), .tri1_out(tri1_out));

    initial begin
        {a, b} = 2'b00; #10;
        if (wand_out !== (a & b)) $display("FAIL wand 00");
        if (wor_out  !== (a | b)) $display("FAIL wor 00");
        {a, b} = 2'b01; #10;
        if (wand_out !== (a & b)) $display("FAIL wand 01");
        if (wor_out  !== (a | b)) $display("FAIL wor 01");
        {a, b} = 2'b10; #10;
        if (wand_out !== (a & b)) $display("FAIL wand 10");
        if (wor_out  !== (a | b)) $display("FAIL wor 10");
        {a, b} = 2'b11; #10;
        if (wand_out !== (a & b)) $display("FAIL wand 11");
        if (wor_out  !== (a | b)) $display("FAIL wor 11");
        if (tri0_out !== 1'b0) $display("FAIL tri0=%b", tri0_out);
        if (tri1_out !== 1'b1) $display("FAIL tri1=%b", tri1_out);
        $display("PASS");
        $finish;
    end
endmodule
