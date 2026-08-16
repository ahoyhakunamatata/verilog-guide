// include_demo 自检测试台
`timescale 1ns/1ps
module include_demo_tb;
    reg  [7:0] din;
    wire [7:0] dout;

    include_demo u_dut (.din(din), .dout(dout));

    initial begin
        din = 8'hA5; #10;
        if (dout !== 8'hA5) $display("FAIL dout=%h", dout);
        $display("PASS");
        $finish;
    end
endmodule
