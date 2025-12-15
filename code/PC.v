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
    else if (JumpPending && En) begin
      // 已经发放过唯一的延迟槽，且流水允许前进：本拍跳转
      PCF         <= JumpTarget;
      PCPlus4F    <= JumpTarget + 4;
      JumpPending <= 1'b0;
      JumpHold    <= 1'b1;   // 标记本次跳转已服务
      JumpTarget  <= 32'b0;
    end
    else if (En && IsJBrD && !JumpHold) begin
      // ID 级检测到跳转/分支：此时 IF 正在取延迟槽，保持 PC 不再顺序前进
      PCF         <= PCF;       // 停在延迟槽地址
      PCPlus4F    <= PCPlus4F;  // 保持
      JumpPending <= 1'b1;      // 挂起跳转，下一拍执行
      JumpTarget  <= NPCD;
      // JumpHold 暂不置位，等真正跳转时置位
    end
    else if (En) begin
      // 普通顺序前进
      PCF         <= PCF + 4;
      PCPlus4F    <= PCF + 8;
      JumpPending <= 1'b0;
      // 若当前不是跳转指令，允许下一次跳转触发
      if (!IsJBrD)
        JumpHold <= 1'b0;
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