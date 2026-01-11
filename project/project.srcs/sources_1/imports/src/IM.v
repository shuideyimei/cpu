`timescale 1us/1us
module IM_2k(					
  input   [10:2]  A,			
  output  [31:0]  RD
  );
  
  reg [31:0] RAM[501:0];
  
  initial
  $readmemh("code.txt", RAM);	
  
  assign RD = RAM[A[10:2]];					
  
endmodule