// $strobe/$fstrobe 执行时机演示（自包含）：用文件捕获输出顺序并回读比对
`timescale 1ns/1ps
module monitor_strobe_tb;
    reg        clk, d;
    reg        q;
    integer    fd;
    reg  [7:0] ch;

    always @(posedge clk) q <= d;   // 非阻塞：时间步末尾更新

    initial begin
        clk = 0; d = 0;
        #1;   // 等首个稳定状态
        fd = $fopen("strobe_capture.txt", "w");
        #4 clk = 1;   // t=5 边沿：d=0，q <= 0
        #1 d = 1;     // t=6 数据变化（与边沿错开，避免竞争）
        #4 clk = 0;   // t=10
        #5 clk = 1;   // t=15 边沿：q <= 1（时间步末尾才更新）
        // 两个打印任务都在 t=15 执行：
        $fdisplay(fd, "DISPLAY %b", q);   // 活动区：看到 NBA 前的旧值 0
        $fstrobe(fd, "STROBE %b", q);     // 时间步末尾：看到最终值 1
        #1;                               // 走完时间步（$fstrobe 已执行），再关文件
        $fclose(fd);

        // 回读文件验证顺序与内容："DISPLAY 0\nSTROBE 1\n"
        fd = $fopen("strobe_capture.txt", "r");
        repeat (8) ch = $fgetc(fd);       // 跳过 "DISPLAY "
        ch = $fgetc(fd);
        if (ch !== "0") $display("FAIL display saw %c", ch);
        ch = $fgetc(fd);                  // 换行
        repeat (7) ch = $fgetc(fd);       // 跳过 "STROBE "
        ch = $fgetc(fd);
        if (ch !== "1") $display("FAIL strobe saw %c", ch);
        $fclose(fd);

        if (q !== 1'b1) $display("FAIL q=%b", q);
        $display("PASS");
        $finish;
    end
endmodule
