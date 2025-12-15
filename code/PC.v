module PC(
  input               clk, rst, En,
  input               IsJBrD,				//是否跳转、分支指�??
  input       [31:0]  NPCD,					//PC按条件自增后的�??
  output  reg [31:0]  PCPlus4F, PCF			//PCPlus4F：实际的PC（下�??条指令处）�?�，PCF：PC当前�??
  );
  
  reg JumpPending;        // 标记是否�?要在下个周期跳转/分支（延迟槽�?
  reg JumpHold;           // 防止同一条跳转指令在 ID 停留时重复触�?
  reg [31:0] JumpTarget;  // 已计算好的跳�?/分支目标地址
  
  initial
  begin
    PCF <= 32'h00003000;
    PCPlus4F <= 32'h00003004;
    JumpPending <= 1'b0;
    JumpHold    <= 1'b0;
    JumpTarget  <= 32'b0;
  end
  
  always @(posedge clk) begin
    // 优先级：rst > 执行挂起跳转 > 捕获跳转请求 > 顺序前进 > 保持
    if (rst) begin
      PCF         <= 32'h00003000;
      PCPlus4F    <= 32'h00003004;
      JumpPending <= 1'b0;
      JumpHold    <= 1'b0;
      JumpTarget  <= 32'b0;
    end
    else if (En) begin
      if (IsJBrD) begin
        // ID 级确认跳转/分支：PC 已经取到延迟槽，下一拍直接跳到目标
        PCF         <= NPCD;
        PCPlus4F    <= NPCD + 4;
      end else begin
        // 普通顺序前进
        PCF         <= PCF + 4;
        PCPlus4F    <= PCF + 8;
      end
      // 跳转状态在本实现已无需挂起，直接清零
      JumpPending <= 1'b0;
      JumpHold    <= 1'b0;
      JumpTarget  <= 32'b0;
    end
    else begin
      // En=0：保持
      PCF         <= PCF;
      PCPlus4F    <= PCPlus4F;
      JumpPending <= JumpPending;
      JumpHold    <= JumpHold;
      JumpTarget  <= JumpTarget;
      if (!IsJBrD)
        JumpHold <= 1'b0;
    end
  end
endmodule