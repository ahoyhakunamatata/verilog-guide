# 10 任务与函数

任务（task）与函数（function）把可复用的行为封装成可调用单元。

## 10.1 function（函数）

- **无时序控制**（不能含 `#`/`@`/`wait`），执行零时间完成
- 返回一个值：函数名即返回变量，返回值位宽可声明（如 `function integer ...`）
- 输入只能是 input；封装**组合逻辑** → ✅ 可综合
- 可声明为 `automatic`：每次调用独立变量空间（递归的前提）

### 示例 10-1：奇偶校验函数

```verilog
--8<-- "examples/10-tasks-functions/function_parity.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/10-tasks-functions/function_parity_tb.v"
    ```

### 示例 10-2：clog2 函数（地址位宽计算）

```verilog
--8<-- "examples/10-tasks-functions/function_clog2.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/10-tasks-functions/function_clog2_tb.v"
    ```

!!! note "关于 $clog2"
    `$clog2` 是 SystemVerilog 的系统函数，**IEEE 1364-2005 纯 Verilog 中没有**。纯 Verilog 工程用示例中的 `clog2` 函数实现。

### 示例 10-3：automatic 函数与递归

```verilog
--8<-- "examples/10-tasks-functions/function_automatic.v"
```

??? note "配套自检测试台"

    ```verilog
    --8<-- "examples/10-tasks-functions/function_automatic_tb.v"
    ```

!!! warning "递归函数的可综合性"
    递归函数仅在**静态可展开**（编译期深度确定）时可能被综合工具支持，工程中递归函数基本只用于仿真/参数推导。

## 10.2 task（任务）

- 可以有**时序控制**、任意多个 input/output/inout
- 主要用于测试台封装激励/检查；❌ 含时序控制的任务不可综合

### 示例 10-4：激励任务封装

```verilog
--8<-- "examples/10-tasks-functions/task_stimulus.v"
```

??? note "配套自检测试台（check_add 任务）"

    ```verilog
    --8<-- "examples/10-tasks-functions/task_stimulus_tb.v"
    ```

!!! tip "使用建议"
    RTL 可综合代码只用 function（组合逻辑封装）；TB 中重复的激励/检查序列用 task 封装。
