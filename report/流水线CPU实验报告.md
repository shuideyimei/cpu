# 五级流水线 MIPS CPU 实验报告

## 一、实验概述

本实验设计并实现了一个五级流水线 MIPS CPU，支持基本的 MIPS 指令集，包括算术运算、逻辑运算、访存指令、分支跳转指令等。流水线分为五个阶段：IF（取指令）、ID（指令译码）、EX（执行）、MEM（访存）、WB（写回）。

## 二、流水线竞争处理

在流水线 CPU 中，由于多条指令同时执行，会出现数据相关和控制相关，导致流水线竞争（Hazard）。本设计通过**旁路转发（Forwarding）**和**流水线阻塞（Stalling）**两种机制来处理这些竞争。

### 2.1 数据冒险（Data Hazard）处理

数据冒险是指后续指令需要使用前面指令的计算结果，但该结果尚未写回寄存器文件。本设计采用旁路转发机制优先处理数据冒险，仅在无法通过转发解决时才进行阻塞。

#### 2.1.1 旁路转发机制

旁路转发允许从流水线寄存器中直接获取数据，而不必等待数据写回寄存器文件。本设计实现了以下转发路径：

**1. ID 阶段的转发（ForwardAD, ForwardBD）**

在 ID 阶段，分支指令和跳转指令需要立即使用寄存器值进行判断。转发逻辑如下：

- **ForwardAD[1:0]**：控制 ID 阶段 Rs 寄存器的数据源选择
  - `00`：从寄存器文件读取（RegFile）
  - `01`：从 MEM 阶段的 ALU 结果转发（ALUOutM）
  - `10`：从 WB 阶段的写回数据转发（ResultW）
  - `11`：从 MEM 阶段的 PC+8 转发（用于 jal/jalr 指令）

- **ForwardBD[1:0]**：控制 ID 阶段 Rt 寄存器的数据源选择，逻辑与 ForwardAD 相同

转发条件判断：
```verilog
assign ForwardAD = ((RsD == WriteRegM) && RegWriteM && (IsJJalM || IsJrJalrM) && (WriteRegM != 5'b00000)) ? 2'b11 :
                   ((RsD == WriteRegM) && RegWriteM && !MemToRegM && (WriteRegM != 5'b00000)) ? 2'b01 :
                   ((RsD == WriteRegW) && RegWriteW && (WriteRegW != 5'b00000)) ? 2'b10 : 2'b00 ;
```

**2. EX 阶段的转发（ForwardAE, ForwardBE）**

在 EX 阶段，ALU 运算需要操作数。转发逻辑如下：

- **ForwardAE[1:0]**：控制 EX 阶段 ALU 第一个操作数的数据源选择
  - `00`：使用 ID 阶段传递过来的数据（SrcA2E）
  - `01`：从 MEM 阶段的 ALU 结果转发（ALUOutM）
  - `10`：从 WB 阶段的写回数据转发（ResultW）

- **ForwardBE[1:0]**：控制 EX 阶段 ALU 第二个操作数的数据源选择，逻辑与 ForwardAE 相同

转发条件判断：
```verilog
assign ForwardAE = ((RsE == WriteRegM) && RegWriteM && (WriteRegM != 5'b00000)) ? 2'b01 :
                   ((RsE == WriteRegW) && RegWriteW && (WriteRegW != 5'b00000)) ? 2'b10 : 2'b00 ;
```

**3. MEM 阶段的转发（ForwardM）**

在 MEM 阶段，存储指令（sw, sh, sb）需要将数据写入内存。如果该数据来自后续指令的计算结果，需要进行转发：

- **ForwardM**：控制 MEM 阶段存储数据的来源
  - `0`：使用 EX 阶段传递过来的数据（WriteDataM）
  - `1`：从 WB 阶段的写回数据转发（ResultW）

转发条件判断：
```verilog
assign ForwardM = ((RtM == WriteRegW) && RegWriteW && (WriteRegW != 5'b00000)) ? 1 : 0;
```

#### 2.1.2 流水线阻塞机制

当遇到 Load-Use 数据冒险时（即后续指令需要使用 Load 指令从内存读取的数据），由于数据在 MEM 阶段结束时才可用，无法通过旁路转发解决，必须阻塞流水线一个周期。

阻塞条件（FlushE）包括：

1. **Load-Use 冒险**：ID 阶段指令需要使用 EX 阶段 Load 指令的结果
   ```verilog
   (UseRsD && (((RsD == WriteRegE) && RegWriteE) || ((RsD == WriteRegM) && MemToRegM && RegWriteM))) ||
   (UseRtD && (((RtD == WriteRegE) && RegWriteE) || ((RtD == WriteRegM) && MemToRegM && RegWriteM)))
   ```

2. **EX 阶段数据冒险**：EX 阶段指令需要使用 EX 阶段指令的结果（且该指令是 Load）
   ```verilog
   (UseRsE && (RsD == WriteRegE) && (MemToRegE || RegWriteE)) ||
   (UseRtE && (RtD == WriteRegE) && (MemToRegE || RegWriteE))
   ```

3. **乘除法单元忙**：当乘除法单元正在执行时，需要阻塞流水线
   ```verilog
   (IsMdD && (BusyE || StartE))
   ```

当 FlushE 信号有效时：
- `StallF = FlushE`：IF 阶段暂停，不更新 PC
- `StallD = FlushE`：ID 阶段暂停，不更新 IF/ID 寄存器
- `FlushE`：EX 阶段清空，将 EX 阶段的指令转换为 NOP（全零）

### 2.2 控制冒险（Control Hazard）处理

控制冒险是指分支指令和跳转指令改变了程序执行流程，导致已取出的指令无效。

#### 2.2.1 分支延迟槽（Branch Delay Slot）

本设计支持 MIPS 的分支延迟槽机制。分支指令后的第一条指令（延迟槽指令）总是会被执行，无论分支是否发生。这简化了控制冒险的处理。

#### 2.2.2 分支预测与刷新

本设计采用**总是预测不跳转**的策略：

1. 在 ID 阶段，NPC 模块计算分支目标地址和跳转目标地址
2. 如果分支条件满足或发生跳转，生成 `IsJBrD` 信号
3. 当 `IsJBrD` 有效时，PC 更新为新的目标地址
4. 同时，通过 `FlushE` 信号清空 EX 阶段的指令（延迟槽指令之后的指令）

分支指令的数据转发：
- 分支指令的比较操作数（Rs, Rt）通过 ForwardAD 和 ForwardBD 从 MEM 或 WB 阶段转发
- 这确保了分支判断使用的是最新的数据值

#### 2.2.3 跳转指令处理

对于 J、JAL、JR、JALR 指令：

1. **J、JAL**：在 ID 阶段即可确定跳转目标地址，立即更新 PC
2. **JR、JALR**：需要从寄存器读取跳转地址，通过 ForwardAD 转发获取最新值
3. 跳转发生时，清空 EX 阶段的指令

### 2.3 特殊情况的处理

#### 2.3.1 寄存器 $0 的处理

MIPS 架构中，寄存器 $0 始终为 0，不能写入。在转发判断中，需要排除对 $0 的转发：
```verilog
(WriteRegM != 5'b00000)  // 确保目标寄存器不是 $0
```

#### 2.3.2 JAL/JALR 指令的 PC+8 转发

JAL 和 JALR 指令需要将返回地址（PC+8）写入 $31 寄存器。在转发时，如果目标寄存器是 $31，且当前 MEM 阶段是 JAL/JALR 指令，则转发 PC+8 而不是 ALU 结果：
```verilog
((RsD == WriteRegM) && RegWriteM && (IsJJalM || IsJrJalrM) && (WriteRegM != 5'b00000)) ? 2'b11
```

#### 2.3.3 乘除法指令的阻塞

乘除法指令（MULT, MULTU, DIV, DIVU）需要多个时钟周期完成。当检测到乘除法指令时：
- 如果乘除法单元忙（BusyE）或正在启动（StartE），阻塞流水线
- 直到乘除法单元空闲，才允许后续指令继续执行

## 三、设计特点

### 3.1 通用转发模式

本设计采用统一的转发判断逻辑，避免了枚举所有可能的转发情况，降低了代码复杂度。转发优先级为：
1. MEM 阶段的结果（最新）
2. WB 阶段的结果（次新）
3. 寄存器文件的值（最旧）

### 3.2 流水线寄存器设计

每一级流水线寄存器都存储了：
- 该阶段需要传递到下一阶段的数据
- 控制信号
- 指令的 PC 值（用于调试和日志输出）

### 3.3 阻塞与刷新机制

- **阻塞（Stall）**：保持当前流水线寄存器的值不变，相当于插入 NOP
- **刷新（Flush）**：将流水线寄存器清零，清除无效指令

## 四、测试验证

本设计通过以下方式验证正确性：

1. **寄存器写入日志**：每次寄存器写入时输出 `@PC: $reg <= value`
2. **内存写入日志**：每次内存写入时输出 `@PC: *addr <= value`
3. **与 MARS 对比**：使用 MARS 模拟器（开启延迟分支）运行相同程序，对比输出日志

测试结果表明，本设计能够正确处理各种数据冒险和控制冒险，输出结果与 MARS 完全一致。

## 五、总结

本五级流水线 MIPS CPU 通过完善的旁路转发和流水线阻塞机制，有效处理了流水线中的各种竞争情况。设计采用通用的转发模式，代码结构清晰，易于维护和扩展。经过充分测试，能够正确执行 MIPS 指令集中的基本指令，满足设计要求。

