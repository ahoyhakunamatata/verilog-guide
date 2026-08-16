// 过程块事件控制：同步复位与异步复位的写法差异
module always_event (
    input  wire clk,
    input  wire rst_n,   // 低有效复位
    input  wire d,
    output reg  q_async,   // 异步复位触发器
    output reg  q_sync     // 同步复位触发器
);
    // 异步复位：复位信号也进敏感列表，不依赖时钟即生效
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q_async <= 1'b0;
        else
            q_async <= d;
    end

    // 同步复位：只在时钟沿采样复位
    always @(posedge clk) begin
        if (!rst_n)
            q_sync <= 1'b0;
        else
            q_sync <= d;
    end
endmodule
