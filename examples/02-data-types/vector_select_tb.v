// vector_select 自检测试台
`timescale 1ns/1ps
module vector_select_tb;
    reg  [7:0] data;
    wire       lsb, msb;
    wire [3:0] low_nibble, high_nibble;

    vector_select u_dut (.data(data), .lsb(lsb), .msb(msb),
                         .low_nibble(low_nibble), .high_nibble(high_nibble));

    initial begin
        data = 8'hA5; #10;   // A5 = 1010_0101
        if (lsb !== 1'b1)         $display("FAIL lsb=%b", lsb);
        if (msb !== 1'b1)         $display("FAIL msb=%b", msb);
        if (low_nibble !== 4'h5)  $display("FAIL low=%h", low_nibble);
        if (high_nibble !== 4'hA) $display("FAIL high=%h", high_nibble);
        $display("PASS");
        $finish;
    end
endmodule
