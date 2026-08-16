// if_case 自检测试台
`timescale 1ns/1ps
module if_case_tb;
    reg  [1:0] sel;
    reg  [3:0] din;
    wire       y_if, y_case;

    if_case u_dut (.sel(sel), .din(din), .y_if(y_if), .y_case(y_case));

    integer i;
    initial begin
        din = 4'b1010;
        for (i = 0; i < 4; i = i + 1) begin
            sel = i[1:0]; #10;
            if (y_if   !== din[sel]) $display("FAIL if sel=%0d", sel);
            if (y_case !== din[sel]) $display("FAIL case sel=%0d", sel);
        end
        $display("PASS");
        $finish;
    end
endmodule
