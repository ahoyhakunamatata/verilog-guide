// 例化连接方式对比：按序连接与按名连接
`include "full_adder_hier.v"

module named_connection (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum_order,   // 按序连接的结果
    output wire cout_order,
    output wire sum_name,    // 按名连接的结果
    output wire cout_name
);
    // 按序连接：参数顺序必须与端口定义顺序完全一致，位置错乱编译器不报错
    full_adder_hier u_order (a, b, cin, sum_order, cout_order);

    // 按名连接：顺序无关、意图清晰，遗漏端口时编译报错（推荐）
    full_adder_hier u_name (
        .cout(cout_name),
        .cin(cin),
        .sum(sum_name),
        .b(b),
        .a(a)
    );
endmodule
