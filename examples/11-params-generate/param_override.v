// 参数重载：#(...) 例化时重载（推荐）与 defparam（不推荐）
module param_override (
    input  wire clk,
    input  wire rst_n,
    output wire [3:0] cnt10,   // MAX=10 的计数器
    output wire [2:0] cnt5     // 默认 MAX=5 的计数器
);
    // 例化时 #(...) 重载：作用范围清晰（推荐）
    counter #(.MAX(4'd10)) u_cnt10 (.clk(clk), .rst_n(rst_n), .count(cnt10));

    counter u_cnt5 (.clk(clk), .rst_n(rst_n), .count(cnt5));   // 用默认参数

    // defparam 重载：作用目标靠层次路径字符串，重构时极易失效（不推荐）
    defparam u_cnt5.MAX = 4'd5;
endmodule

// 通用计数器：0 到 MAX-1 循环
module counter #(
    parameter MAX = 4'd5
) (
    input  wire clk,
    input  wire rst_n,
    output reg  [3:0] count
);
    always @(posedge clk) begin
        if (!rst_n)
            count <= 4'd0;
        else if (count == MAX - 1'b1)
            count <= 4'd0;
        else
            count <= count + 1'b1;
    end
endmodule
