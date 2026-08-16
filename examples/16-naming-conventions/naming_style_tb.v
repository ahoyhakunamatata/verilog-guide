// naming_style 自检测试台
`timescale 1ns/1ps
module naming_style_tb;
    reg        clk, rst_n, din_valid_en;
    reg  [7:0] din_valid;
    wire [7:0] dout_data;

    naming_style u_dut (.clk(clk), .rst_n(rst_n), .din_valid(din_valid),
                        .din_valid_en(din_valid_en), .dout_data(dout_data));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    initial begin
        clk = 0; rst_n = 0; din_valid = 8'h0; din_valid_en = 1'b0;
        tick; #1;
        if (dout_data !== 8'h00) $display("FAIL reset=%h", dout_data);
        rst_n = 1;
        din_valid = 8'hA5; din_valid_en = 1'b1;
        tick; #1;
        if (dout_data !== 8'hA5) $display("FAIL load=%h", dout_data);
        din_valid = 8'h5A; din_valid_en = 1'b0;
        tick; #1;   // 使能关闭：保持
        if (dout_data !== 8'hA5) $display("FAIL hold=%h", dout_data);
        $display("PASS");
        $finish;
    end
endmodule
