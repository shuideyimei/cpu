# MIPS 五级流水线 CPU

基于 Verilog/SystemVerilog 实现的五级流水线 MIPS CPU，支持完整的 MIPS-C3 指令集（50 条指令）。

## 项目简介

本项目实现了一个功能完整的 MIPS 五级流水线 CPU，采用经典的 IF / ID / EX / MEM / WB 五级流水结构。CPU 支持数据冒险和控制冒险的硬件处理机制，包括旁路转发（Forwarding）、流水线阻塞（Stalling）、分支延迟槽（Delay Slot）以及多周期乘除法单元阻塞等特性。

### 主要特性

- **五级流水线架构**：IF（取指）→ ID（译码）→ EX（执行）→ MEM（访存）→ WB（写回）
- **完整的冒险处理机制**：
  - 数据冒险：旁路转发和 Load-Use 冒险阻塞
  - 控制冒险：分支延迟槽
  - 多周期乘除法单元支持
- **非对齐访存支持**：支持字节/半字的非对齐访存操作
- **系统调用支持**：支持 syscall 指令（功能号 1 和 10）

## 支持的指令集

### ALU 指令
- ADD, ADDU, SUB, SUBU, SLL, SRL, SRA, SLLV, SRLV, SRAV
- AND, OR, XOR, NOR, SLT, SLTU

### 立即数指令
- LUI, ADDI, ADDIU, ANDI, ORI, XORI, SLTI, SLTIU

### 乘除法指令
- MULT, MULTU, DIV, DIVU, MFHI, MTHI, MFLO, MTLO

### 分支指令
- BEQ, BNE, BLEZ, BGTZ, BGEZ, BLTZ

### 跳转指令
- J, JAL, JR, JALR

### 访存指令
- LB, LBU, LH, LHU, LW, SB, SH, SW

### 系统调用
- syscall（支持功能号 1：整数输出，功能号 10：程序退出）

## 硬件架构

### 核心模块

| 模块名称 | 描述 |
|---------|------|
| `MIPS.sv` | CPU 顶层模块，集成五级流水线数据通路和控制通路 |
| `TopLevel.v` | 顶层封装，便于测试平台对接 |
| `ALU.v` | 算术逻辑单元 |
| `RegFile.v` | 32 位通用寄存器堆 |
| `IM.v` | 指令存储器（2KB） |
| `DM.v` | 数据存储器（4KB） |
| `Ctrl.v` | 主控制单元 |
| `Hazard.v` | 冒险检测与处理单元 |
| `MultiplicationDivisionUnit.sv` | 多周期乘除法单元 |
| `BECtrl.v` | 字节使能控制（处理非对齐访存） |
| `DMExt.v` | 数据存储器读出数据扩展 |

### 流水线寄存器
- `RegD.v` - ID 阶段流水寄存器
- `RegE.v` - EX 阶段流水寄存器
- `RegM.v` - MEM 阶段流水寄存器
- `RegW.v` - WB 阶段流水寄存器

### 其他模块
- `NPC.v` - 下一 PC 计算单元
- `PC.v` - 程序计数器
- `Ext.v` - 立即数扩展单元
- `Comp.v` - 分支条件比较单元
- `MUX.v` - 多路选择器
- `StartCtrl.v` - 乘除法启动控制

## 项目结构

```
MIPS_CPU/
├── project/                          # Vivado 项目目录
│   ├── project.srcs/
│   │   └── sources_1/
│   │       └── imports/src/          # 源代码
│   │           ├── MIPS.sv           # CPU 核心
│   │           ├── TopLevel.v        # 顶层模块
│   │           ├── mips_tb.v         # 测试平台
│   │           └── ...               # 其他模块
│   ├── project.sim/                  # 仿真文件
│   └── project.xpr                   # Vivado 项目文件
├── pipeline-tester-py/               # Python 测试工具
│   ├── main.py                       # 主测试脚本
│   └── mips-asm-test/                # 测试集
├── question/                         # 实验文档
├── check.py                          # 项目检查脚本
├── meta.json                         # 项目配置
├── pyproject.toml                    # Python 项目配置
└── README.md                         # 项目说明
```

## 快速开始

### 环境要求

- **Vivado** 2018.3 或更高版本
- **Python** 3.11+
- **MARS** MIPS 模拟器（用于参考输出对比）

### 仿真步骤

1. **打开 Vivado 项目**
   ```bash
   vivado project/project.xpr
   ```

2. **运行仿真**
   - 在 Vivado 中选择 "Run Simulation" → "Run Behavioral Simulation"
   - 或使用 TCL 脚本：
     ```tcl
     cd project
     vivado -mode batch -source run.tcl
     ```

3. **查看结果**
   - 仿真日志将输出到仿真控制台
   - 可在波形窗口查看各信号时序

### 使用 Python 测试工具

```bash
cd pipeline-tester-py
python main.py
```

测试工具会：
- 自动运行所有测试程序
- 与 MARS 模拟器输出进行对比
- 生成测试报告

## 测试与验证

### 测试环境
- **仿真工具**：Vivado xsim
- **参考模拟器**：MARS 4.5（开启延迟分支模式）
- **自动化测试**：pipeline-tester-py

### 测试集
- 官方示例程序：add、gcd、lfsr、pointer-chasing、floyd 等
- 随机测试程序：覆盖各种指令组合与冒险情况
- 在数百次测试中与 MARS 输出完全一致

## 冒险处理机制

### 数据冒险 - 旁路转发
- ID 阶段转发：`ForwardAD`、`ForwardBD`（用于分支/跳转指令）
- EX 阶段转发：`ForwardAE`、`ForwardBE`（用于 ALU 操作数）
- MEM 阶段转发：`ForwardM`（用于存储指令写数据）

### Load-Use 冒险
- 检测到 Load-Use 冒险时自动插入气泡
- 阻塞 IF/ID 级，冲刷 ID/EX 级

### 分支延迟槽
- 支持 MIPS 标准的分支延迟槽语义
- 延迟槽指令必须执行一次，不被冲刷

### 乘除法器冒险
- 多周期乘除法单元带 `busy` 和 `start` 控制
- MDU 忙时自动阻塞相关指令

## 开发与调试

### 项目检查脚本

```bash
python check.py meta.json
```

检查项目配置是否正确，包括：
- 测试文件路径
- 源代码文件
- 时序标尺设置
- Vivado 项目配置

### 配置文件

`meta.json` 文件定义了项目的关键路径：
```json
{
  "compiler": "vivado",
  "test_file": "./project/project.xpr",
  "data_path": "./project/project.srcs/sources_1/imports/src/DM.v",
  "code_path": "./project/project.srcs/sources_1/imports/src/IM.v"
}
```

## 技术细节

### 非对齐访存处理
- **写操作**：按字写入（32 位）
- **读操作**：根据字节使能进行符号/零扩展

### Syscall 实现
- 寄存器 `$v0`（$2）存放功能号
- 寄存器 `$a0`（$4）存放参数
- 功能号 1：输出 `$a0` 的有符号整数值
- 功能号 10：结束仿真（`$finish`）

### 时序与性能
- 时钟周期：1us（`timescale 1us/1us`）
- 乘法延迟：5 个周期
- 除法延迟：10 个周期

## 参考资料

- [MIPS-C3 指令集手册](https://www.mips.com/)
- [Hennessy & Patterson - Computer Organization and Design](https://www.elsevier.com/books/computer-organization-and-design/patterson/978-0-12-820331-6)

## 许可证

本项目仅用于教学和学习目的。
