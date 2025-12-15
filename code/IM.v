module IM_2k(					//数据存储器为 RAM 类型的存储器， 在写入时需要时钟上升沿和控制信号。分配 512 个字存
								//储空间，字长为 32 位，容量为 2K。
  input   [10:2]  A,			//9 位地址
  output  [31:0]  RD
  );
  
  reg [31:0] RAM[501:0];
  
  initial $readmemh("E:/Code/CPU_Design/HFUT_2020_MIPS_CPU/pipeline-tester-py/code.txt", RAM);		//把测试数据读入 RAM 中 
  
  assign RD = RAM[A[10:2]];					//把对应9位地址的 RAM 内容 赋值給RD
  
endmodule