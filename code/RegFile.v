module RegFile(							//寄存器文件，实现了 32 个 32 位通用整数寄存器，
										//可以同时进行两个寄存器的读操作和一个寄存器的写操作，时钟下降沿使能则写入。
  input           clk, rst, WE3,
  input   [4:0]   A1, A2, A3,			//第 一/二/三 个读寄存器地址（编号）
  input   [31:0]  WD3,					//要写入的数据
  input   [31:0]  PC,                   //触发该写入的指令地址
  output  [31:0]  SrcAD, SrcBD,			//2个从寄存器读出的数据
  output  [31:0]  V0DataRaw, A0DataRaw		//$v0 (reg 2) 和 $a0 (reg 4) 的值，用于 syscall
  );
  
  reg [31:0] Regs[31:0];
  
  integer i;
  
  initial
    for (i = 0; i < 32; i = i + 1)
      Regs[i] <= 0;
  
  always @(rst)
    for (i = 0; i < 32; i = i + 1)
      Regs[i] <= 0;
  
  reg [4:0] lastWriteReg;
  reg [31:0] lastWritePC;
  
  always @(posedge clk) begin
    if (WE3 == 1'b1) begin
      // 1. 检查是否是同一PC的重复写入，如果是则不打印
      if (!(lastWriteReg == A3 && lastWritePC == PC)) begin
        if (PC != 32'b0) begin
          $display("@%08h: $%2d <= %08h", PC, A3, WD3);
        end
      end
      
      // 2. 寄存器写入操作 (必须在 A3 != 0 的前提下)
      if (A3 != 5'b00000) begin
        Regs[A3] <= WD3;
      end
      
      // 3. 记录本次写入的寄存器和PC，用于下个周期检查重复
      // 无论是否进行了 $display，只要 WE3=1 就记录，因为写入操作已经发生。
      lastWriteReg <= A3;
      lastWritePC <= PC;
    end
    // *** 移除 WE3 == 0 时的 lastWriteReg/PC 清除逻辑 ***
  end
    
  assign SrcAD = ((WE3 == 1'b1) && (A3 == A1) && (A3 != 5'b00000)) ? WD3 : Regs[A1];
  assign SrcBD = ((WE3 == 1'b1) && (A3 == A2) && (A3 != 5'b00000)) ? WD3 : Regs[A2];
  
  // Additional read ports for syscall: $v0 (reg 2) and $a0 (reg 4)
  assign V0DataRaw = ((WE3 == 1'b1) && (A3 == 5'b00010) && (A3 != 5'b00000)) ? WD3 : Regs[2];
  assign A0DataRaw = ((WE3 == 1'b1) && (A3 == 5'b00100) && (A3 != 5'b00000)) ? WD3 : Regs[4];
  
endmodule