// 偶数分频器：4 分频（50% 占空比）——经典计数器 + cnt[1] 写法
module clk_divider (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div4
);
    reg [1:0] cnt;

    always @(posedge clk) begin
        if (!rst_n)
            cnt <= 2'd0;
        else
            cnt <= cnt + 1'b1;
    end

    // cnt: 0,1,2,3 循环；cnt[1]: 0,0,1,1 → 4 分频、占空比 50%
    assign clk_div4 = cnt[1];
endmodule
