// register_bank 自检测试台：逐地址写入并验证，再验证 we=0 保持
`timescale 1ns/1ps
module register_bank_tb;
    reg        clk, rst_n, we;
    reg  [1:0] addr;
    reg  [7:0] wdata;
    wire [7:0] q0, q1, q2, q3;

    register_bank u_dut (.clk(clk), .rst_n(rst_n), .we(we), .addr(addr),
                         .wdata(wdata), .q0(q0), .q1(q1), .q2(q2), .q3(q3));

    task tick;
        begin #5 clk = 1'b1; #5 clk = 1'b0; end
    endtask

    reg [7:0] regs [0:3];
    integer i;
    initial begin
        clk = 0; rst_n = 0; we = 0; addr = 0; wdata = 0;
        tick; #1;
        if (q0 !== 0 || q1 !== 0 || q2 !== 0 || q3 !== 0) $display("FAIL reset");
        rst_n = 1;
        for (i = 0; i < 4; i = i + 1) begin   // 逐地址写入
            addr = i[1:0]; wdata = 8'h10 + i; we = 1;
            tick; #1;
            regs[i] = 8'h10 + i;
        end
        if (q0 !== regs[0] || q1 !== regs[1] || q2 !== regs[2] || q3 !== regs[3])
            $display("FAIL write");
        we = 0; addr = 2'd2; wdata = 8'hFF;   // 写使能关闭：必须保持
        tick; #1;
        if (q0 !== regs[0] || q1 !== regs[1] || q2 !== regs[2] || q3 !== regs[3])
            $display("FAIL hold");
        $display("PASS");
        $finish;
    end
endmodule
