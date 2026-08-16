// loops 自检测试台
`timescale 1ns/1ps
module loops_tb;
    reg  [3:0] din;
    wire [3:0] rev, count_ones;

    loops u_dut (.din(din), .rev(rev), .count_ones(count_ones));

    initial begin
        din = 4'b1011; #10;
        if (rev        !== 4'b1101) $display("FAIL rev=%b", rev);
        if (count_ones !== 4'd3)    $display("FAIL count=%0d", count_ones);

        din = 4'b0000; #10;
        if (rev        !== 4'b0000) $display("FAIL rev2=%b", rev);
        if (count_ones !== 4'd0)    $display("FAIL count2=%0d", count_ones);

        din = 4'b1111; #10;
        if (count_ones !== 4'd4)    $display("FAIL count3=%0d", count_ones);
        $display("PASS");
        $finish;
    end
endmodule
