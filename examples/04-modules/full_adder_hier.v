// 层次化结构描述：全加器由两个半加器和一个或门组成
// 通过 `include 复用同目录下的 half_adder_gates 模块定义（详见第 12 章）
`include "half_adder_gates.v"

module full_adder_hier (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire s1, c1, c2;

    half_adder_gates u_ha1 (.a(a),  .b(b),   .sum(s1),  .carry(c1));
    half_adder_gates u_ha2 (.a(s1), .b(cin), .sum(sum), .carry(c2));
    or (cout, c1, c2);
endmodule
