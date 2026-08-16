// shift_concat 自检测试台
`timescale 1ns/1ps
module shift_concat_tb;
    reg  [3:0] a;
    wire [7:0] shl, shr, concat, replic;

    shift_concat u_dut (.a(a), .shl(shl), .shr(shr),
                        .concat(concat), .replic(replic));

    initial begin
        a = 4'b1010; #10;
        if (shl    !== 8'b0010_1000) $display("FAIL shl=%b", shl);
        if (shr    !== 8'b0000_0010) $display("FAIL shr=%b", shr);
        if (concat !== 8'b1010_0000) $display("FAIL concat=%b", concat);
        if (replic !== 8'b1010_1010) $display("FAIL replic=%b", replic);
        $display("PASS");
        $finish;
    end
endmodule
