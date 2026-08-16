// 标识符与注释：大小写敏感、转义标识符
module identifiers_comments (
    output wire data_bus,   // 小写
    output wire data_BUS    // 大写：与 data_bus 是两个不同的标识符（大小写敏感）
);
    // 单行注释：从 // 到行尾

    /* 块注释：可以跨行，但不能嵌套
       （块注释内再出现“斜杠星号”会被判定提前结束） */

    wire \escaped!name ;            // 转义标识符：以反斜杠开头，以空白字符结束，
                                    // 可包含任意可打印字符（本示例含 ! 和 .）

    assign \escaped!name  = 1'b1;
    assign data_bus       = 1'b0;
    assign data_BUS       = \escaped!name ;
endmodule
