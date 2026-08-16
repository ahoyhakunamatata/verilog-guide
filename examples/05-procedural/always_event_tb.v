// always_event 自检测试台：对比异步复位与同步复位的时序行为
// 时钟手动打拍（tick 任务），保证验证时序完全确定
`timescale 1ns/1ps
module always_event_tb;
    reg        clk, rst_n, d;
    wire       q_async, q_sync;

    always_event u_dut (.clk(clk), .rst_n(rst_n), .d(d),
                        .q_async(q_async), .q_sync(q_sync));

    task tick;          // 产生一个时钟脉冲：上升沿在 #5 处
        begin
            #5 clk = 1'b1;
            #5 clk = 1'b0;
        end
    endtask

    initial begin
        clk = 0; rst_n = 1; d = 0;
        #10;
        d = 1; tick; #1;
        if (q_async !== 1'b1) $display("FAIL async set=%b", q_async);
        if (q_sync  !== 1'b1) $display("FAIL sync set=%b", q_sync);

        rst_n = 0; #15;   // 复位拉低，期间不打时钟
        if (q_async !== 1'b0) $display("FAIL async reset immediate=%b", q_async);
        if (q_sync  !== 1'b1) $display("FAIL sync reset should wait clock=%b", q_sync);

        tick; #1;         // 时钟沿到来，同步复位才生效
        if (q_sync !== 1'b0) $display("FAIL sync reset at clock=%b", q_sync);

        rst_n = 1; tick; #1;
        if (q_async !== 1'b1 || q_sync !== 1'b1) $display("FAIL release");
        $display("PASS");
        $finish;
    end
endmodule
