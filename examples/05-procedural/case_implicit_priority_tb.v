// case_implicit_priority 自检测试台
`timescale 1ns/1ps
module case_implicit_priority_tb;
    reg  [1:0] sel;
    reg  [1:0] din;
    wire       y;

    case_implicit_priority u_dut (.sel(sel), .din(din), .y(y));

    initial begin
        din = 2'b10;
        sel = 2'b10; #10;   // 只匹配第一项
        if (y !== din[1]) $display("FAIL sel=10 y=%b", y);
        sel = 2'b01; #10;   // 只匹配第二项
        if (y !== din[0]) $display("FAIL sel=01 y=%b", y);
        sel = 2'b11; #10;   // 两项都匹配：先匹配者胜（隐式优先级）
        if (y !== din[1]) $display("FAIL sel=11 y=%b", y);
        sel = 2'b00; #10;   // 都不匹配
        if (y !== 1'b0) $display("FAIL sel=00 y=%b", y);
        sel = 2'bz1; #10;   // 陷阱：casez 把 z 当通配符，匹配第一项
        if (y !== din[1]) $display("FAIL sel=z1 y=%b", y);
        $display("PASS");
        $finish;
    end
endmodule
