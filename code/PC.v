module PC(
  input               clk, rst, En,
  input               IsJBrD,				//是否跳转、分支指�?
  input       [31:0]  NPCD,					//PC按条件自增后的�??
  output  reg [31:0]  PCPlus4F, PCF			//PCPlus4F：实际的PC（下�?条指令处）�?�，PCF：PC当前�?
  );
  
  initial
  begin
    PCF <= 32'h00003000;
    PCPlus4F <= 32'h00003004;
  end
  
  always @(posedge clk)
  begin
    if (rst)
    begin
      PCF <= 32'h00003000;
      PCPlus4F <= 32'h00003004;
    end
    else if (IsJBrD)
    begin
      // Jump/branch takes priority over stall
      PCF <= NPCD;
      PCPlus4F <= NPCD + 4;
    end
    else if (!En)
    begin
      PCF <= PCF;
      PCPlus4F <= PCPlus4F;
    end
    else
    begin
      PCF <= PCF + 4;
      PCPlus4F <= PCF + 8;
    end
  end
endmodule