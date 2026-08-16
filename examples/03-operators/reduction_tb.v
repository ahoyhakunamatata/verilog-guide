// reduction 自检测试台
`timescale 1ns/1ps
module reduction_tb;
    reg  [3:0] a;
    wire       all_ones, any_one, parity, nand_all, nor_all, xnor_all;

    reduction u_dut (.a(a), .all_ones(all_ones), .any_one(any_one),
                     .parity(parity), .nand_all(nand_all),
                     .nor_all(nor_all), .xnor_all(xnor_all));

    initial begin
        a = 4'b1111; #10;   // 4 个 1：与缩减=1，异或缩减=0（偶数个 1）
        if (all_ones !== 1'b1) $display("FAIL all_ones=%b", all_ones);
        if (any_one  !== 1'b1) $display("FAIL any_one=%b", any_one);
        if (parity   !== 1'b0) $display("FAIL parity=%b", parity);
        if (nand_all !== 1'b0) $display("FAIL nand_all=%b", nand_all);
        if (nor_all  !== 1'b0) $display("FAIL nor_all=%b", nor_all);
        if (xnor_all !== 1'b1) $display("FAIL xnor_all=%b", xnor_all);

        a = 4'b0111; #10;   // 3 个 1：异或缩减=1（奇数个 1）
        if (all_ones !== 1'b0) $display("FAIL all_ones2=%b", all_ones);
        if (any_one  !== 1'b1) $display("FAIL any_one2=%b", any_one);
        if (parity   !== 1'b1) $display("FAIL parity2=%b", parity);
        if (xnor_all !== 1'b0) $display("FAIL xnor_all2=%b", xnor_all);

        a = 4'b0000; #10;
        if (any_one  !== 1'b0) $display("FAIL any_one3=%b", any_one);
        if (nor_all  !== 1'b1) $display("FAIL nor_all3=%b", nor_all);
        $display("PASS");
        $finish;
    end
endmodule
