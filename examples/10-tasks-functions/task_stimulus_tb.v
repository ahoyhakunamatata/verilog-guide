// task_stimulus 自检测试台：用任务封装"施加激励 + 结果检查"
`timescale 1ns/1ps
module task_stimulus_tb;
    reg  [3:0] a, b;
    wire [4:0] sum;

    task_stimulus u_dut (.a(a), .b(b), .sum(sum));

    // 任务：可含时序控制、多个输出，调用像一条语句
    task check_add;
        input [3:0] ta, tb;   // 任务输入：调用时传参
        reg   [4:0] expected; // 任务内局部变量
        begin
            a = ta; b = tb;
            #10;
            expected = {1'b0, ta} + {1'b0, tb};
            if (sum !== expected) $display("FAIL %0d+%0d=%0d", ta, tb, sum);
        end
    endtask

    initial begin
        a = 0; b = 0;
        check_add(4'd3, 4'd5);
        check_add(4'd15, 4'd1);   // 进位
        check_add(4'd0, 4'd0);
        $display("PASS");
        $finish;
    end
endmodule
