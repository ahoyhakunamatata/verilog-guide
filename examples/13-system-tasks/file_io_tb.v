// 文件 I/O 往返验证（自包含）：写入两个十六进制数，再读出比对
`timescale 1ns/1ps
module file_io_tb;
    integer    fd, rc;
    reg  [7:0] a, b;

    initial begin
        fd = $fopen("io_test.txt", "w");
        if (fd == 0) $display("FAIL fopen w");
        $fdisplay(fd, "%h %h", 8'hA5, 8'h5A);
        $fclose(fd);

        fd = $fopen("io_test.txt", "r");
        if (fd == 0) $display("FAIL fopen r");
        rc = $fscanf(fd, "%h %h", a, b);
        $fclose(fd);

        if (rc !== 2)    $display("FAIL rc=%0d", rc);
        if (a !== 8'hA5) $display("FAIL a=%h", a);
        if (b !== 8'h5A) $display("FAIL b=%h", b);
        $display("PASS");
        $finish;
    end
endmodule
