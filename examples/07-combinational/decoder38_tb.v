// decoder38 自检测试台
`timescale 1ns/1ps
module decoder38_tb;
    reg  [2:0] sel;
    reg        en;
    wire [7:0] y;

    decoder38 u_dut (.sel(sel), .en(en), .y(y));

    integer i;
    initial begin
        en = 1'b0; sel = 3'd0; #10;
        if (y !== 8'h00) $display("FAIL en=0 y=%h", y);
        en = 1'b1;
        for (i = 0; i < 8; i = i + 1) begin
            sel = i[2:0]; #10;
            if (y !== (8'b1 << sel)) $display("FAIL sel=%0d y=%h", sel, y);
        end
        $display("PASS");
        $finish;
    end
endmodule
