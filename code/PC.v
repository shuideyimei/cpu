module PC(
  input               clk, rst, En,
  input               IsJBrD,				//是否跳转、分支指�?
  input       [31:0]  NPCD,					//PC按条件自增后的�??
  output  reg [31:0]  PCPlus4F, PCF			//PCPlus4F：实际的PC（下�?条指令处）�?�，PCF：PC当前�?
  );
  
  reg JumpPending;        // 标记是否需要在下个周期跳转/分支（延迟槽）
  reg JumpHold;           // 防止同一条跳转指令在 ID 停留时重复触发
  reg [31:0] JumpTarget;  // 已计算好的跳转/分支目标地址
  
  initial
  begin
    PCF <= 32'h00003000;
    PCPlus4F <= 32'h00003004;
    JumpPending <= 1'b0;
    JumpHold    <= 1'b0;
    JumpTarget  <= 32'b0;
  end
  
  always @(posedge clk) begin
    // 优先级：rst > 完成延迟槽后的跳转（需要 En=1）> 记录跳转请求 > 顺序执行/停顿
    if (rst) begin
      PCF         <= 32'h00003000;
      PCPlus4F    <= 32'h00003004;
      JumpPending <= 1'b0;
      JumpHold    <= 1'b0;
      JumpTarget  <= 32'b0;
    end
    // 跳转执行：只在流水允许前进 (En=1) 且已经经历过 1 条延迟槽时
    else if (JumpPending && En) begin
      PCF         <= JumpTarget;
      PCPlus4F    <= JumpTarget + 4;
      JumpPending <= 1'b0;     // 固定 1 条延迟槽
      JumpHold    <= 1'b1;     // 标记该跳转已服务
      JumpTarget  <= 32'b0;
    end
    else begin
      // 默认保持
      PCF         <= PCF;
      PCPlus4F    <= PCPlus4F;

      // 记录新的跳转请求（仅在未服务过且未在等待中）
      if (IsJBrD && !JumpHold && !JumpPending) begin
        JumpPending <= 1'b1;
        JumpTarget  <= NPCD;
      end

      // 顺序推进 PC：需要 En=1 且当前没有等待跳转
      if (En && !JumpPending) begin
        PCF      <= PCF + 4;
        PCPlus4F <= PCF + 8;
      end

      // 当 ID 不再是跳转/分支指令时，允许下一条跳转再次触发
      if (!IsJBrD)
        JumpHold <= 1'b0;
    end
  end
endmodule