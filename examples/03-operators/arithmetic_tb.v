// arithmetic 自检测试台
`timescale 1ns/1ps
module arithmetic_tb;
    reg  [7:0]  a, b;
    wire [8:0]  sum;
    wire [7:0]  diff, quotient, remainder;
    wire [15:0] product, square;

    arithmetic u_dut (.a(a), .b(b), .sum(sum), .diff(diff), .product(product),
                      .quotient(quotient), .remainder(remainder), .square(square));

    initial begin
        a = 8'd200; b = 8'd55; #10;
        if (sum       !== 9'd255)  $display("FAIL sum=%0d", sum);
        if (diff      !== 8'd145)  $display("FAIL diff=%0d", diff);
        if (product   !== 16'd11000) $display("FAIL product=%0d", product);
        if (quotient  !== 8'd3)    $display("FAIL quotient=%0d", quotient);
        if (remainder !== 8'd35)   $display("FAIL remainder=%0d", remainder);
        if (square    !== 16'd40000) $display("FAIL square=%0d", square);

        a = 8'd255; b = 8'd1; #10;
        if (sum !== 9'd256)        $display("FAIL sum2=%0d", sum);

        a = 8'd12; b = 8'd5; #10;
        if (square !== 16'd144)    $display("FAIL square2=%0d", square);
        $display("PASS");
        $finish;
    end
endmodule
