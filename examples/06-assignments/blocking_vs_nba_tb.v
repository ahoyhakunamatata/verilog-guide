// blocking_vs_nba 自检测试台
`timescale 1ns/1ps
module blocking_vs_nba_tb;
    reg  clk, d;
    wire q1_b, q2_b, q1_n, q2_n;

    blocking_vs_nba u_dut (.clk(clk), .d(d),
                           .q1_b(q1_b), .q2_b(q2_b), .q1_n(q1_n), .q2_n(q2_n));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    initial begin
        clk = 0; d = 0;
        tick; #1;   // 第一个沿：清掉 x
        d = 1; tick; #1;
        // 非阻塞：q1_n=1（新值），q2_n=0（q1_n 旧值）——正确移位
        if (q1_n !== 1'b1) $display("FAIL q1_n=%b", q1_n);
        if (q2_n !== 1'b0) $display("FAIL q2_n=%b", q2_n);
        // 阻塞：两级同值——并非移位
        if (q1_b !== 1'b1) $display("FAIL q1_b=%b", q1_b);
        if (q2_b !== 1'b1) $display("FAIL q2_b=%b", q2_b);

        tick; #1;
        if (q2_n !== 1'b1) $display("FAIL q2_n after 2nd=%b", q2_n);
        $display("PASS");
        $finish;
    end
endmodule
