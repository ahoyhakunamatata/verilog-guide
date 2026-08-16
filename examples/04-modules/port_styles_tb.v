// port_styles 自检测试台：两种声明风格功能必须一致
`timescale 1ns/1ps
module port_styles_tb;
    reg  [3:0] a, b;
    wire [3:0] y_ansi, y_old;

    port_styles_ansi u_ansi (.a(a), .b(b), .y(y_ansi));
    port_styles_old  u_old  (.a(a), .b(b), .y(y_old));

    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            {a, b} = i[3:0];
            #10;
            if (y_ansi !== (a & b)) $display("FAIL ansi i=%0d", i);
            if (y_old  !== (a & b)) $display("FAIL old  i=%0d", i);
        end
        $display("PASS");
        $finish;
    end
endmodule
