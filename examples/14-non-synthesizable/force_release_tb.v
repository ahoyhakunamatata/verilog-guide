// force/release（仅仿真）：错误注入与强制测试点；释放后恢复被强制前的值
`timescale 1ns/1ps
module force_release_tb;
    reg  [3:0] cnt;

    initial begin
        cnt = 0;
        repeat (5) begin
            #10 cnt = cnt + 1'b1;
        end
        if (cnt !== 4'd5) $display("FAIL normal=%0d", cnt);

        force cnt = 4'hF;   // 强制为 F：期间其他赋值全部无效
        #10;
        if (cnt !== 4'hF) $display("FAIL forced=%0d", cnt);

        release cnt;        // 释放：reg 保持被强制值，直到下一次过程赋值
        if (cnt !== 4'hF) $display("FAIL released=%0d", cnt);

        #10 cnt = cnt + 1'b1;   // 恢复常规驱动：F+1=16 截断为 0
        if (cnt !== 4'd0) $display("FAIL resumed=%0d", cnt);
        $display("PASS");
        $finish;
    end
endmodule
