// 命名事件与 -> 触发（仅仿真）：跨进程同步
`timescale 1ns/1ps
module event_trigger_tb;
    event ev_done;   // event 类型：无值，仅作同步点
    reg   fired, observed;

    initial begin
        fired = 0; observed = 0;
        fork
            begin
                #5 -> ev_done;   // 触发事件
                fired = 1;
            end
            begin
                @ev_done;        // 等待事件（同一时刻触发即可被捕获）
                observed = 1;
            end
        join
        if (fired !== 1'b1 || observed !== 1'b1) $display("FAIL event sync");
        $display("PASS");
        $finish;
    end
endmodule
