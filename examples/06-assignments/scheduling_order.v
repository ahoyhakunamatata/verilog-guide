// 事件调度演示：时钟沿块内，非阻塞赋值的更新发生在时间步末尾
module scheduling_order (
    input  wire clk,
    input  wire d,
    output reg  q,
    output reg  shadow   // 记录块内读到的 q 值（旧值）
);
    always @(posedge clk) begin
        q      <= d;      // 非阻塞：时间步末尾才更新
        shadow = q;       // 阻塞读：此刻 q 尚未更新，读到旧值
    end
endmodule
