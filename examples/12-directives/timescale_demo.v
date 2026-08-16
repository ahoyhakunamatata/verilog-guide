// `timescale：时间单位与精度（1ns 单位、1ps 精度，支持 0.1ns 级小数延时）
`timescale 1ns/1ps

module timescale_demo (
    output reg pulse
);
    initial begin
        pulse = 1'b0;
        #10.5 pulse = 1'b1;   // 小数延时：精度 1ps 允许
        #10.0 pulse = 1'b0;
    end
endmodule
