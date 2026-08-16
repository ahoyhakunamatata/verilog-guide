// comb_template 自检测试台：两种模板结果必须一致
`timescale 1ns/1ps
module comb_template_tb;
    reg  [3:0] a, b;
    reg        sel;
    wire [3:0] y_always, y_assign;

    comb_template u_dut (.a(a), .b(b), .sel(sel),
                         .y_always(y_always), .y_assign(y_assign));

    initial begin
        a = 4'hA; b = 4'h5;
        sel = 1'b0; #10;
        if (y_always !== 4'hA || y_assign !== 4'hA) $display("FAIL sel=0");
        sel = 1'b1; #10;
        if (y_always !== 4'h5 || y_assign !== 4'h5) $display("FAIL sel=1");
        $display("PASS");
        $finish;
    end
endmodule
