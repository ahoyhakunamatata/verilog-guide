// 存储器数组：reg 的数组，整体元素访问（mem[addr]），不支持 mem[addr][bit] 混选
module memory (
    input  wire       clk,
    input  wire       we,       // 写使能
    input  wire [1:0] waddr,
    input  wire [1:0] raddr,
    input  wire [7:0] wdata,
    output reg  [7:0] rdata
);
    reg [7:0] mem [0:3];   // 4 元素 x 8 位的存储器

    always @(posedge clk) begin
        if (we)
            mem[waddr] <= wdata;
        rdata <= mem[raddr];   // 读为异步定位、同步输出
    end
endmodule
