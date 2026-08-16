// # 延时控制（仅仿真）：精确时间推进，支持小数（依赖 timescale 精度）
`timescale 1ns/1ps
module delay_control_tb;
    reg  [1:0] sig;
    real       r_start;

    initial begin
        sig = 2'b00;
        r_start = $realtime;
        #10.5 sig = 2'b01;   // 小数延时 10.5ns
        // 注意：real 类型只能用 ==/!=（===/!== 仅用于四态值）
        if ($realtime - r_start != 10.5) $display("FAIL t1=%f", $realtime - r_start);
        #10 sig = 2'b10;
        if ($realtime - r_start != 20.5) $display("FAIL t2=%f", $realtime - r_start);
        #10 sig = 2'b11;
        if (sig !== 2'b11) $display("FAIL sig=%b", sig);
        $display("PASS");
        $finish;
    end
endmodule
