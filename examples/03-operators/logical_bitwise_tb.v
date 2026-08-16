// logical_bitwise 自检测试台
`timescale 1ns/1ps
module logical_bitwise_tb;
    reg  [3:0] a, b;
    wire [3:0] bw_and, bw_or, bw_xor, bw_not;
    wire       lg_and, lg_or, lg_not;

    logical_bitwise u_dut (.a(a), .b(b), .bw_and(bw_and), .bw_or(bw_or),
                           .bw_xor(bw_xor), .bw_not(bw_not),
                           .lg_and(lg_and), .lg_or(lg_or), .lg_not(lg_not));

    initial begin
        a = 4'b1010; b = 4'b0101; #10;
        if (bw_and !== 4'b0000) $display("FAIL bw_and=%b", bw_and);
        if (bw_or  !== 4'b1111) $display("FAIL bw_or=%b", bw_or);
        if (bw_xor !== 4'b1111) $display("FAIL bw_xor=%b", bw_xor);
        if (bw_not !== 4'b0101) $display("FAIL bw_not=%b", bw_not);
        if (lg_and !== 1'b1)    $display("FAIL lg_and=%b", lg_and);
        if (lg_or  !== 1'b1)    $display("FAIL lg_or=%b", lg_or);
        if (lg_not !== 1'b0)    $display("FAIL lg_not=%b", lg_not);

        a = 4'b0000; b = 4'b0011; #10;
        if (bw_and !== 4'b0000) $display("FAIL bw_and2=%b", bw_and);
        if (bw_or  !== 4'b0011) $display("FAIL bw_or2=%b", bw_or);
        if (bw_not !== 4'b1111) $display("FAIL bw_not2=%b", bw_not);
        if (lg_and !== 1'b0)    $display("FAIL lg_and2=%b", lg_and);
        if (lg_or  !== 1'b1)    $display("FAIL lg_or2=%b", lg_or);
        if (lg_not !== 1'b1)    $display("FAIL lg_not2=%b", lg_not);
        $display("PASS");
        $finish;
    end
endmodule
