// automatic 函数与递归：阶乘计算
// automatic：每次调用拥有独立变量空间（递归的前提）
module function_automatic (
    input  wire [3:0]  n,
    output wire [31:0] fact
);
    function automatic integer factorial;
        input [3:0] n;
        begin
            if (n <= 1)
                factorial = 1;
            else
                factorial = n * factorial(n - 1);   // 递归调用
        end
    endfunction

    assign fact = factorial(n);
endmodule
