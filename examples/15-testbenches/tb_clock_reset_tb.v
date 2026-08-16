// 时钟与复位生成（自包含）：两种时钟写法 + 上电复位序列
`timescale 1ns/1ps
module tb_clock_reset_tb;
    reg clk_a, clk_b;
    reg rst_n;

    // 方法一：always + 半周期延时（最常用）
    always #5 clk_a = ~clk_a;

    // 方法二：initial + forever（可控制初始相位）
    initial begin
        clk_b = 1'b1;   // 与 clk_a 反相开始
        forever begin
            #5 clk_b = ~clk_b;
        end
    end

    // 复位序列：上电先复位，保持 2.5 个周期再释放
    initial begin
        clk_a = 0;
        rst_n = 1'b0;
        #25 rst_n = 1'b1;
    end

    // 时序检查：采样点刻意避开 5ns 的整数倍（时钟翻转时刻），消除竞争
    initial begin
        #12;   // t=12：clk_a 在 t=10 翻转为 0；clk_b 在 t=10 翻转为 1
        if (clk_a !== 1'b0) $display("FAIL clk_a@12=%b", clk_a);
        if (clk_b !== 1'b1) $display("FAIL clk_b@12=%b", clk_b);
        #5;    // t=17：clk_a 在 t=15 翻转为 1；复位仍未释放（t=25 才释放）
        if (clk_a !== 1'b1) $display("FAIL clk_a@17=%b", clk_a);
        if (rst_n !== 1'b0) $display("FAIL rst_n@17=%b", rst_n);
        #11;   // t=28：复位已释放；clk_a 在 t=25 翻转为 1
        if (rst_n !== 1'b1) $display("FAIL rst_n@28=%b", rst_n);
        if (clk_a !== 1'b1) $display("FAIL clk_a@28=%b", clk_a);
        $display("PASS");
        $finish;
    end
endmodule
