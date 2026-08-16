// 阻塞赋值与非阻塞赋值的经典对比：两条语句试图描述"二级移位"
module blocking_vs_nba (
    input  wire clk,
    input  wire d,
    output reg  q1_b,   // 阻塞写法
    output reg  q2_b,
    output reg  q1_n,   // 非阻塞写法
    output reg  q2_n
);
    // 阻塞：q1_b 立即更新，紧接着的 q2_b = q1_b 读到的是新值
    always @(posedge clk) begin
        q1_b = d;
        q2_b = q1_b;     // 结果：q2_b 与 q1_b 同值，不是移位！
    end

    // 非阻塞：右侧在块开始时统一采样，左侧在时间步末尾统一更新
    always @(posedge clk) begin
        q1_n <= d;
        q2_n <= q1_n;    // q2_n 得到 q1_n 的旧值：正确的一级移位
    end
endmodule
