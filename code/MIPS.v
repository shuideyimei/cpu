`include "MDU.SV"

module MIPS(					//实例化以上各个模块，并将各模块用线连接起来
  input clk, rst
  );
  

  wire        BranchD, CompD, StallF, StallD, FlushE;
  wire        RegWriteD, MemWriteD, MemToRegD, RegDstD, RegWriteW;
  wire        RegWriteE, RegDstE, MemWriteE, MemToRegE, StartD, StartE;
  wire        RegWriteM, MemWriteM, MemToRegM, MemToRegW, IsJrJalrD;
  wire        IsMdD, BusyE, IsJJalM, IsJrJalrM, ForwardM, IsJBrD, IsJJalD;
  wire        IsLbSbD, IsLhShD, IsUnsignedD, HiLoWriteD, HiLoD, IsShamtD, IsShamtE, IsSyscallD;
  wire        IsJJalE, IsJrJalrE, IsLbSbE, IsLhShE, IsUnsignedE, HiLoWriteE, HiLoE, IsSyscallE;
  wire        IsLbSbM, IsLhShM, IsUnsignedM, IsJJalW, IsJrJalrW, IsUnsignedW, IsSyscallM, IsSyscallW;
  wire [1:0]  ALUSrcD, ALUSrcE, ForwardAD, ForwardBD, ForwardAE, ForwardBE, MdOpD, MdOpE, ExtOpD;
  wire [2:0]  CompOpD;
  wire [3:0]  ALUControlD, ALUControlE, BEOutM, BEOutW;
  wire [4:0]  RsD, RtD, RdD, WriteRegW, RsE, RtE, RdE, RtM, ShamtD, ShamtE;
  wire [4:0]  WriteRegE, WriteReg2E, WriteRegM;
  wire [5:0]  OpD, FunctD;
  wire [31:0] NPCD, PCPlus4F, PCF, PCPlus4D, PCPlus8M, PCPlus8E, PCPlus8W, Result1W;
  wire [31:0] InstrF, InstrD, ResultW, SrcAD, SrcBD, ALUOutM, SrcA2D, SrcB2D, ImmD, ImmE;
  wire [31:0] SrcA2E, SrcB2E, SrcA3E, SrcB3E, ALUOutE, WriteDataM, ReadDataM;
  wire [31:0] ALUOutW, ReadDataW, WriteData2M, SrcA4E, SrcB4E, Lo, Hi, ReadDataExtW;
  wire [31:0] MDUDataRead, V0DataRaw, A0DataRaw, V0Data, A0Data;
  wire [1:0] ForwardV0, ForwardA0;
  mdu_operation_t MDUOperationE;
  
  // Hazard
  Hazard Hazard(OpD, RsD, RtD, RsE, RtE, RtM, WriteReg2E, WriteRegM, WriteRegW,
                ALUSrcD, IsJrJalrD, BranchD, IsMdD, BusyE, StartE, IsJJalM, IsJrJalrM,
                IsJJalD,
                MemToRegE, MemToRegM, MemWriteM, RegWriteE, RegWriteM, RegWriteW,
                StallF, StallD, FlushE, ForwardAD, ForwardBD, ForwardAE, ForwardBE, ForwardM);
  
  // IF
  PC PC(clk, rst, !StallF, IsJBrD, NPCD, PCPlus4F, PCF);
  IM_2k IM(PCF[10:2], InstrF);
  
  // ID
  assign OpD    = InstrD[31:26];
  assign FunctD = InstrD[5:0];
  assign RsD    = InstrD[25:21];
  assign RtD    = InstrD[20:16];
  assign RdD    = InstrD[15:11];
  assign ShamtD = InstrD[10:6];
  RegD RegD(clk, rst, !StallD, InstrF, PCPlus4F, InstrD, PCPlus4D);
  Ctrl Ctrl(OpD, FunctD, RtD, RegWriteD, MemWriteD, MemToRegD, RegDstD, BranchD,
            IsJJalD, IsJrJalrD, IsLbSbD, IsLhShD, IsUnsignedD, HiLoWriteD, HiLoD,
            IsMdD, IsShamtD, IsSyscallD, MdOpD, ALUControlD, ALUSrcD, ExtOpD, CompOpD);
  wire [31:0] PCW;
  RegFile RegFile(clk, rst, RegWriteW, RsD, RtD, WriteRegW, ResultW, PCW, SrcAD, SrcBD, V0DataRaw, A0DataRaw);
  MUX4 #(32) ForwardSrcAMUX(SrcAD, ALUOutM, ResultW, PCPlus8M, ForwardAD, SrcA2D);
  MUX4 #(32) ForwardSrcBMUX(SrcBD, ALUOutM, ResultW, PCPlus8M, ForwardBD, SrcB2D);
  Comp Comp(SrcA2D, SrcB2D, CompOpD, CompD);
  Ext Ext(InstrD[15:0], ExtOpD, ImmD);
  NPC NPC(PCPlus4D, InstrD[25:0], {ImmD[29:0], 2'b00}, SrcA2D, IsJJalD,
          IsJrJalrD, BranchD, CompD, NPCD, IsJBrD);
  StartCtrl StartCtrl(InstrD, BusyE, StartD);
  
  // EX
  // Pass PC+4 directly so jal/jalr write-back stores the correct return address
  RegE RegE(clk, rst, FlushE, PCPlus4D, SrcA2D, SrcB2D, RsD, RtD, RdD, ShamtD, ImmD,
            RegWriteD, RegDstD, MemWriteD, MemToRegD, ALUControlD, ALUSrcD, StartD, IsJJalD,
            IsJrJalrD, IsLbSbD, IsLhShD, IsUnsignedD, HiLoWriteD, HiLoD, IsShamtD, IsSyscallD, MdOpD,
            PCPlus8E, SrcA2E, SrcB2E, RsE, RtE, RdE, ShamtE, ImmE, RegWriteE, RegDstE, MemWriteE, MemToRegE,
            ALUControlE, ALUSrcE, StartE, IsJJalE, IsJrJalrE, IsLbSbE, IsLhShE, IsUnsignedE,
            HiLoWriteE, HiLoE, IsShamtE, IsSyscallE, MdOpE);
  // Select operands for ALU
  MUX3 #(32) ForwardAEMUX(SrcA2E, ALUOutM, ResultW, ForwardAE, SrcA3E);
  MUX2 #(32) ShamtMUX(SrcA3E, {27'b0, ShamtE}, IsShamtE, SrcA4E);
  MUX3 #(32) ForwardBEMUX(SrcB2E, ALUOutM, ResultW, ForwardBE, SrcB3E);
  MUX4 #(32) ALUSrcBMUX(SrcB3E, ImmE, Lo, Hi, ALUSrcE, SrcB4E);
  ALU ALU(SrcA4E, SrcB4E, ALUControlE, ALUOutE);

  // Drive MDU operation based on EX stage control
  always @(*) begin
    // Default to read LO to keep a deterministic value on Lo
    MDUOperationE = MDU_READ_LO;
    if (HiLoWriteE) begin
      // MTHI / MTLO
      MDUOperationE = HiLoE ? MDU_WRITE_HI : MDU_WRITE_LO;
    end
    else if (StartE) begin
      // MULT / MULTU / DIV / DIVU start
      case (MdOpE)
        2'b01: MDUOperationE = MDU_START_SIGNED_MUL;
        2'b00: MDUOperationE = MDU_START_UNSIGNED_MUL;
        2'b11: MDUOperationE = MDU_START_SIGNED_DIV;
        2'b10: MDUOperationE = MDU_START_UNSIGNED_DIV;
      endcase
    end
    else begin
      // MFHI / MFLO reads
      if (ALUSrcE == 2'b10)
        MDUOperationE = MDU_READ_LO;
      else if (ALUSrcE == 2'b11)
        MDUOperationE = MDU_READ_HI;
    end
  end

  // Multiplication / Division Unit
  MultiplicationDivisionUnit MDU(
    .reset   (rst),
    .clock   (clk),
    .operand1(SrcA4E),
    .operand2(SrcB4E),
    .operation(MDUOperationE),
    .start   (StartE),
    .busy    (BusyE),
    .dataRead(MDUDataRead)
  );

  // Expose HI / LO values for MFHI / MFLO selection (only used when selected by ALUSrcE)
  assign Lo = MDUDataRead;
  assign Hi = MDUDataRead;
  MUX2 #(5) WriteRegMUX(RdE, RtE, RegDstE, WriteRegE);
  MUX2 #(5) JJalMux(WriteRegE, 5'b11111, IsJJalE, WriteReg2E);
  
  // MEM
  RegM RegM(clk, rst, PCPlus8E, ALUOutE, SrcB3E, RtE, WriteReg2E, RegWriteE, MemWriteE, MemToRegE,
            IsJJalE, IsJrJalrE, IsLbSbE, IsLhShE, IsUnsignedE, IsSyscallE,
            PCPlus8M, ALUOutM, WriteDataM, RtM, WriteRegM, RegWriteM, MemWriteM, MemToRegM,
            IsJJalM, IsJrJalrM, IsLbSbM, IsLhShM, IsUnsignedM, IsSyscallM);
  BECtrl BECtrl(ALUOutM[1:0], IsLhShM, IsLbSbM, BEOutM);
  MUX2 #(32) ForwardMMUX(WriteDataM, ResultW, ForwardM, WriteData2M);
  wire [31:0] PCM;
  // PCPlus8M now carries PC+4; subtract 4 to recover the instruction PC for DM log
  assign PCM = (PCPlus8M >= 32'd8) ? (PCPlus8M - 32'd8) : 32'd0;
  DM_4k DM(ALUOutM[11:2], WriteData2M, clk, MemWriteM, BEOutM, PCM, ReadDataM);
  
  // WB
  RegW RegW(clk, rst, PCPlus8M, ALUOutM, ReadDataM, WriteRegM, RegWriteM, MemToRegM,
            IsJJalM, IsJrJalrM, IsUnsignedM, IsSyscallM, BEOutM,
            PCPlus8W, PCW, ALUOutW, ReadDataW, WriteRegW, RegWriteW, MemToRegW,
            IsJJalW, IsJrJalrW, IsUnsignedW, IsSyscallW, BEOutW);
  DMExt DMExt(ReadDataW, BEOutW, IsUnsignedW, ReadDataExtW);
  MUX2 #(32) MemToRegMUX(ALUOutW, ReadDataExtW, MemToRegW, Result1W);
  MUX2 #(32) IsJMUX(Result1W, PCPlus8W, IsJJalW || IsJrJalrW, ResultW);
  
  // No forwarding needed for Syscall in WB stage as it is the oldest instruction.
  // Using forwarding would incorrectly pick up values from younger instructions in MEM/EX.
  assign V0Data = V0DataRaw;
  assign A0Data = A0DataRaw;
  
  // Syscall handling in WB stage
  // Execute syscall when it reaches WB stage
  // Note: V0Data and A0Data are combinational, computed from forwarding logic
  always @(posedge clk) begin
    if (!rst && IsSyscallW) begin
      // Check syscall function code in $v0
      // Debug: Print values to verify forwarding
       $display("DEBUG: syscall at PC %h, V0Data=%d, A0Data=%d, ForwardA0=%b, WriteRegM=%d, WriteRegW=%d", 
               PCW, V0Data, A0Data, ForwardA0, WriteRegM, WriteRegW);
      if (V0Data == 32'd10) begin
        // Syscall 10: Exit program
        $finish;
      end
      else if (V0Data == 32'd1) begin
        // Syscall 1: Print integer from $a0
        $fwrite(1, "%d\n", $signed(A0Data));
      end
    end
  end
  
endmodule