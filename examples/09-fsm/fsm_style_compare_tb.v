// fsm_style_compare 自检测试台：两种写法的检测输出必须逐拍一致
`timescale 1ns/1ps
module fsm_style_compare_tb;
    reg  clk, rst_n, din;
    wire detect_1stage, detect_3stage;

    fsm_style_compare u_dut (.clk(clk), .rst_n(rst_n), .din(din),
                             .detect_1stage(detect_1stage), .detect_3stage(detect_3stage));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    integer k;
    reg [7:0] seq;
    initial begin
        clk = 0; rst_n = 0; din = 0; seq = 8'b1101_1010;
        tick; #1;
        rst_n = 1;
        for (k = 0; k < 8; k = k + 1) begin
            din = seq[7 - k];
            tick; #1;
            if (detect_1stage !== detect_3stage)
                $display("FAIL mismatch k=%0d 1s=%b 3s=%b", k, detect_1stage, detect_3stage);
            if (detect_3stage !== ((k == 3) || (k == 6)))
                $display("FAIL k=%0d detect=%b", k, detect_3stage);
        end
        $display("PASS");
        $finish;
    end
endmodule
