// register_enable 自检测试台
`timescale 1ns/1ps
module register_enable_tb;
    reg  [7:0] din;
    reg        en, clk, rst_n;
    wire [7:0] q;

    register_enable u_dut (.din(din), .en(en), .clk(clk), .rst_n(rst_n), .q(q));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    initial begin
        clk = 0; rst_n = 0; din = 8'h00; en = 1'b0;
        tick; #1;   // 复位
        if (q !== 8'h00) $display("FAIL reset=%h", q);
        rst_n = 1;
        din = 8'hA5; en = 1'b1; tick; #1;
        if (q !== 8'hA5) $display("FAIL load=%h", q);
        din = 8'h5A; en = 1'b0; tick; #1;   // en=0：保持
        if (q !== 8'hA5) $display("FAIL hold=%h", q);
        en = 1'b1; tick; #1;
        if (q !== 8'h5A) $display("FAIL load2=%h", q);
        $display("PASS");
        $finish;
    end
endmodule
