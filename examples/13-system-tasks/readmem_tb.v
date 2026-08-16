// $readmemh 存储器初始化（自包含）：从 rom.hex 加载并逐项比对
`timescale 1ns/1ps
module readmem_tb;
    reg [7:0] mem [0:3];

    initial begin
        $readmemh("rom.hex", mem);   // 相对当前运行目录（示例所在章节目录）
        #10;
        if (mem[0] !== 8'h00) $display("FAIL m0=%h", mem[0]);
        if (mem[1] !== 8'hA5) $display("FAIL m1=%h", mem[1]);
        if (mem[2] !== 8'h5A) $display("FAIL m2=%h", mem[2]);
        if (mem[3] !== 8'hFF) $display("FAIL m3=%h", mem[3]);
        $display("PASS");
        $finish;
    end
endmodule
