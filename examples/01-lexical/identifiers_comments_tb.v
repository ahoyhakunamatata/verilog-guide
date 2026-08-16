// identifiers_comments 自检测试台
`timescale 1ns/1ps
module identifiers_comments_tb;
    wire data_bus, data_BUS;

    identifiers_comments u_dut (.data_bus(data_bus), .data_BUS(data_BUS));

    initial begin
        #10;
        if (data_bus !== 1'b0) $display("FAIL data_bus =%b", data_bus);
        if (data_BUS !== 1'b1) $display("FAIL data_BUS =%b", data_BUS);
        $display("PASS");
        $finish;
    end
endmodule
