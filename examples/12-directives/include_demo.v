// `include：把共享定义头文件内联到当前文件（相对当前编译目录解析）
`include "defs.h"

module include_demo (
    input  wire [`VEC_W-1:0] din,
    output wire [`VEC_W-1:0] dout
);
    assign dout = din & `MASK_ALL;
endmodule
