// part_select 自检测试台
`timescale 1ns/1ps
module part_select_tb;
    reg  [1:0] index;
    reg  [7:0] data;
    wire [1:0] pair;

    part_select u_dut (.index(index), .data(data), .pair(pair));

    initial begin
        data = 8'b1101_0010;
        index = 2'd0; #10;
        if (pair !== 2'b10) $display("FAIL index=0 pair=%b", pair);
        index = 2'd1; #10;
        if (pair !== 2'b00) $display("FAIL index=1 pair=%b", pair);
        index = 2'd2; #10;
        if (pair !== 2'b01) $display("FAIL index=2 pair=%b", pair);
        index = 2'd3; #10;
        if (pair !== 2'b11) $display("FAIL index=3 pair=%b", pair);
        $display("PASS");
        $finish;
    end
endmodule
