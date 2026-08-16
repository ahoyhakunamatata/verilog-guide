// fork/join 并行语句块（仅仿真）：join 等待所有分支完成
// 注：join_any/join_none（2001 新增）本工具链的 -g2005 模式不支持，未演示
`timescale 1ns/1ps
module fork_join_tb;
    reg a, b, c;

    initial begin
        a = 0; b = 0; c = 0;
        fork
            #10 a = 1;
            #20 b = 1;
            #30 c = 1;
        join   // 三条全部完成后才继续：此时 t=30
        if (a !== 1'b1 || b !== 1'b1 || c !== 1'b1) $display("FAIL join");

        a = 0; b = 0; c = 0;
        fork
            begin   // 分支内多条语句用 begin/end 封装
                #10 a = 1;
                #10 a = 0;   // 分支内第 20ns 完成
            end
            #15 b = 1;       // 第 15ns 完成
            #5  c = 1;       // 第 5ns 完成
        join   // 等待最慢分支：t=20
        if (a !== 1'b0) $display("FAIL branch a=%b", a);
        if (b !== 1'b1) $display("FAIL branch b=%b", b);
        if (c !== 1'b1) $display("FAIL branch c=%b", c);
        $display("PASS");
        $finish;
    end
endmodule
