# SYSCALL 指令实现说明

## 实现概述

已成功实现 SYSCALL 指令的完整功能，包括：
- **Syscall 10**：终止仿真（`$finish`）
- **Syscall 1**：输出整数（从 `$a0` 寄存器读取值并输出）

## 实现细节

### 1. 指令检测（Ctrl.v）

在 `Ctrl.v` 中添加了 SYSCALL 指令的检测：
- 添加了 `SYSCALL = 6'b001100` 参数定义
- 在 R-type 指令的 case 语句中添加了 SYSCALL 的处理
- 添加了 `IsSyscallD` 输出信号，用于标识 syscall 指令

```verilog
SYSCALL: CtrlCode <= 28'b0_0_00_0_0_0000_0_00_0_0_000_0_0_0_00_0_0_0_0_1;
```

### 2. 信号传递

`IsSyscallD` 信号沿着流水线传递：
- **ID → EX**：通过 `RegE` 模块传递 `IsSyscallD` → `IsSyscallE`
- **EX → MEM**：通过 `RegM` 模块传递 `IsSyscallE` → `IsSyscallM`
- **MEM → WB**：通过 `RegW` 模块传递 `IsSyscallM` → `IsSyscallW`

### 3. 寄存器文件扩展（RegFile.v）

在 `RegFile.v` 中添加了两个额外的读取端口：
- `V0Data`：读取 `$v0` 寄存器（reg 2）的值
- `A0Data`：读取 `$a0` 寄存器（reg 4）的值

这两个端口支持转发，确保读取到的是最新值。

### 4. Syscall 处理逻辑（MIPS.v）

在 `MIPS.v` 的 WB 阶段实现了 syscall 处理：

```verilog
always @(posedge clk) begin
  if (!rst && IsSyscallW) begin
    // Check syscall function code in $v0
    if (V0Data == 32'd10) begin
      // Syscall 10: Exit program
      $finish;
    end
    else if (V0Data == 32'd1) begin
      // Syscall 1: Print integer from $a0
      $display("%d", $signed(A0Data));
    end
  end
end
```

## 使用方法

### Syscall 1：输出整数

```assembly
ori $v0, $0, 1      # Set $v0 = 1 (print integer syscall)
ori $a0, $0, 42     # Set $a0 = 42 (value to print)
syscall             # Execute syscall
```

输出：`42`

### Syscall 10：终止程序

```assembly
ori $v0, $0, 10     # Set $v0 = 10 (exit syscall)
syscall             # Execute syscall (terminates simulation)
```

## 测试

已创建测试程序 `TESTBENCH/test_syscall.s`，包含：
1. Syscall 1 的测试（输出整数 42）
2. Syscall 10 的测试（终止程序）

## 注意事项

1. **寄存器转发**：`$v0` 和 `$a0` 的读取支持转发，确保在 syscall 执行时能获取到最新值
2. **时序**：Syscall 处理在 WB 阶段进行，此时指令已完成执行，寄存器值已更新
3. **符号扩展**：Syscall 1 输出时使用 `$signed(A0Data)` 进行符号扩展，支持有符号整数输出

## 修改的文件列表

1. `code/Ctrl.v` - 添加 SYSCALL 指令检测
2. `code/RegE.v` - 传递 IsSyscallE 信号
3. `code/RegM.v` - 传递 IsSyscallM 信号
4. `code/RegW.v` - 传递 IsSyscallW 信号
5. `code/RegFile.v` - 添加 V0Data 和 A0Data 读取端口
6. `code/MIPS.v` - 实现 syscall 处理逻辑

## 完成状态

✅ 所有功能已实现并测试通过

