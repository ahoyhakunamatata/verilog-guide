// gen_if_case 自检测试台：三种 MODE 的实例各自验证
`timescale 1ns/1ps
module gen_if_case_tb;
    reg  [7:0] din;
    wire [7:0] dout0, dout1, dout2;

    gen_if_case #(.MODE(0)) u0 (.din(din), .dout(dout0));
    gen_if_case #(.MODE(1)) u1 (.din(din), .dout(dout1));
    gen_if_case #(.MODE(2)) u2 (.din(din), .dout(dout2));

    initial begin
        din = 8'hA5; #10;
        if (dout0 !== 8'hA5) $display("FAIL mode0=%h", dout0);
        if (dout1 !== 8'h5A) $display("FAIL mode1=%h", dout1);
        if (dout2 !== 8'hA6) $display("FAIL mode2=%h", dout2);
        $display("PASS");
        $finish;
    end
endmodule
