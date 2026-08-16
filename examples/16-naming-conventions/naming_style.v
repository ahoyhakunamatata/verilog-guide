// 命名规范示例：模块/信号/参数的命名约定
module naming_style #(
    parameter DATA_WIDTH = 8        // 参数：全大写下划线（可重载）
) (
    input  wire                  clk,           // 时钟：clk（多域加域说明，如 clk_ddr）
    input  wire                  rst_n,         // 低有效复位：_n 后缀
    input  wire [DATA_WIDTH-1:0] din_valid,     // 数据信号：含义明确的完整单词
    input  wire                  din_valid_en,  // 使能：_en 后缀
    output reg  [DATA_WIDTH-1:0] dout_data      // 输出：方向_含义（dout_*）
);
    reg [DATA_WIDTH-1:0] dout_data_next;        // 次态信号：_next 后缀

    always @(*) begin
        if (din_valid_en)
            dout_data_next = din_valid;
        else
            dout_data_next = dout_data;         // 无使能时保持
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            dout_data <= {DATA_WIDTH{1'b0}};
        else
            dout_data <= dout_data_next;
    end
endmodule
