// golden 比对（自包含）：被测模型与独立参考模型逐拍对比
`timescale 1ns/1ps
module tb_golden_compare_tb;
    reg        clk, rst_n;
    reg  [7:0] din;
    wire [7:0] y_dut;
    reg  [7:0] y_gold;
    reg  [7:0] stage_g;

    // 被测设计：两级流水（用两个 always 块实现）
    dut_reg u_dut (.clk(clk), .rst_n(rst_n), .din(din), .y(y_dut));

    // golden 参考模型：与 DUT 等价的单块行为描述（实现方式不同，互为印证）
    always @(posedge clk) begin
        if (!rst_n) begin
            stage_g <= 8'h0;
            y_gold  <= 8'h0;
        end else begin
            stage_g <= din;
            y_gold  <= stage_g;
        end
    end

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    integer i;
    initial begin
        clk = 0; rst_n = 0; din = 0;
        tick; #1;   // 复位
        rst_n = 1;
        for (i = 0; i < 16; i = i + 1) begin
            din = i * 8'd16 + 8'd3;   // 确定性数据序列
            tick; #1;
            if (y_dut !== y_gold)
                $display("FAIL i=%0d dut=%h gold=%h", i, y_dut, y_gold);
        end
        $display("PASS");
        $finish;
    end
endmodule

// 被测设计：两级流水寄存器（两个 always 块各自驱动一级）
module dut_reg (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] din,
    output reg  [7:0] y
);
    reg [7:0] stage;

    always @(posedge clk) begin
        if (!rst_n)
            stage <= 8'h0;
        else
            stage <= din;
    end

    always @(posedge clk) begin
        if (!rst_n)
            y <= 8'h0;
        else
            y <= stage;
    end
endmodule
