// VCD 波形转储（自包含）：$dumpfile/$dumpvars 生成波形文件
`timescale 1ns/1ps
module vcd_dump_tb;
    reg        clk;
    reg  [3:0] cnt;

    always #5 clk = ~clk;   // 自由运行时钟

    initial begin
        clk = 0; cnt = 0;
        $dumpfile("vcd_dump.vcd");
        $dumpvars(0, vcd_dump_tb);   // 转储本模块及以下全部信号
        repeat (20) begin
            #10 cnt = cnt + 1'b1;
        end
        if (cnt !== 4'd20) $display("FAIL cnt=%0d", cnt);
        $display("PASS");
        $finish;
    end
endmodule
