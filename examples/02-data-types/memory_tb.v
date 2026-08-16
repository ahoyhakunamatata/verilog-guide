// memory 自检测试台：先写入 4 个地址，再依次读出比对
`timescale 1ns/1ps
module memory_tb;
    reg        clk;
    reg        we;
    reg  [1:0] waddr, raddr;
    reg  [7:0] wdata;
    wire [7:0] rdata;

    memory u_dut (.clk(clk), .we(we), .waddr(waddr), .raddr(raddr),
                  .wdata(wdata), .rdata(rdata));

    always #5 clk = ~clk;   // 10ns 周期时钟

    integer i;

    initial begin
        clk = 0; we = 0; waddr = 0; raddr = 0; wdata = 0;
        #1;  // 等待稳定
        for (i = 0; i < 4; i = i + 1) begin   // 写阶段
            waddr = i[1:0]; wdata = 8'h10 + i; we = 1;
            @(negedge clk);   // 等待一个周期
        end
        we = 0;
        for (i = 0; i < 4; i = i + 1) begin   // 读阶段
            raddr = i[1:0];
            @(posedge clk); #1;               // 采样 rdata
            if (rdata !== (8'h10 + i)) $display("FAIL raddr=%0d rdata=%h", i, rdata);
        end
        $display("PASS");
        $finish;
    end
endmodule
