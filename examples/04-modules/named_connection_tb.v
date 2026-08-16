// named_connection 自检测试台：两种连接方式结果必须一致
`timescale 1ns/1ps
module named_connection_tb;
    reg  a, b, cin;
    wire sum_order, cout_order, sum_name, cout_name;

    named_connection u_dut (.a(a), .b(b), .cin(cin),
                            .sum_order(sum_order), .cout_order(cout_order),
                            .sum_name(sum_name),   .cout_name(cout_name));

    integer i;
    reg [1:0] expected;

    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i[2:0];
            #10;
            expected = a + b + cin;
            if ({cout_order, sum_order} !== expected) $display("FAIL order i=%0d", i);
            if ({cout_name,  sum_name}  !== expected) $display("FAIL name i=%0d", i);
        end
        $display("PASS");
        $finish;
    end
endmodule
