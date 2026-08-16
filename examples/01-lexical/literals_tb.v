// literals 自检测试台：用 === 比较（含 x/z 位时普通 == 结果为 x）
`timescale 1ns/1ps
module literals_tb;
    wire [7:0] bin_hex, with_xz, neg_value;

    literals u_dut (.bin_hex(bin_hex), .with_xz(with_xz), .neg_value(neg_value));

    initial begin
        #10;
        if (bin_hex   !== 8'hAA)        $display("FAIL bin_hex   =%h", bin_hex);
        if (with_xz   !== 8'b10xz_01zz) $display("FAIL with_xz   =%b", with_xz);
        if (neg_value !== 8'hFB)        $display("FAIL neg_value =%h", neg_value);
        $display("PASS");
        $finish;
    end
endmodule
