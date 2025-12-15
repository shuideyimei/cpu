module PC(
  input               clk, rst, En,
  input               IsJBrD,				//是否跳转、分支指�?
  input       [31:0]  NPCD,					//PC按条件自增后的�??
  output  reg [31:0]  PCPlus4F, PCF			//PCPlus4F：实际的PC（下�?条指令处）�?�，PCF：PC当前�?
  );
  
  reg JumpPending;        // 标记是否需要在下个周期跳转/分支（延迟槽）
  reg [31:0] JumpTarget;  // 已计算好的跳转/分支目标地址
  
  initial
  begin
    PCF <= 32'h00003000;
    PCPlus4F <= 32'h00003004;
  end
  
  always @(posedge clk) begin
    // 预先缓存一次跳转请求，避免 En=0 时丢失
    // 优先级：rst > 执行跳转 > 缓存跳转请求 > 顺序执行/停顿
    if (rst) begin
      PCF         <= 32'h00003000;
      PCPlus4F    <= 32'h00003004;
      JumpPending <= 1'b0;
      JumpTarget  <= 32'b0;
    end
    else if (JumpPending) begin
      // 已经经历过 1 条延迟槽，本周期跳到目标
      PCF         <= JumpTarget;
      PCPlus4F    <= JumpTarget + 4;
      JumpPending <= 1'b0;        // 跳一次就清空，固定 1 条延迟槽
      JumpTarget  <= 32'b0;
    end
    else begin
      // 默认保持
      PCF         <= PCF;
      PCPlus4F    <= PCPlus4F;
      JumpPending <= JumpPending;
      JumpTarget  <= JumpTarget;

      // 若检测到跳转/分支，先缓存目标（即便 En=0 也不丢）
      if (IsJBrD && !JumpPending) begin
        JumpPending <= 1'b1;
        JumpTarget  <= NPCD;
      end

      // 只有在未处于 JumpPending 状态且允许前进时才顺序推进 PC
      if (En && !JumpPending) begin
        PCF      <= PCF + 4;
        PCPlus4F <= PCF + 8;
      end
    end
  end
endmodule