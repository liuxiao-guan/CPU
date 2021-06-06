`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:19:26 11/29/2017 
// Design Name: 
// Module Name:    mips 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mips(
    input clk,
    input reset
    );
	 
	 wire [5:0] op, func;
	 wire RegWrite, ALUSelA, ALUSelB, MemWrie;
	 wire [1:0] RegWriteCtr, RegSel, MemWriteCtr, EXTCtr;
	 wire [3:0] ALUCtr;
	 wire [2:0] MemOutCtr, nPCSel;
	 
	 Controller Controller(.op(op),
	                       .func(func),
								  .RegWrite(RegWrite),
								  .RegWriteCtr(RegWriteCtr),
								  .RegSel(RegSel),
								  .ALUSelA(ALUSelA),
								  .ALUSelB(ALUSelB),
								  .ALUCtr(ALUCtr),
								  .MemWrite(MemWrite),
								  .MemWriteCtr(MemWriteCtr),
								  .MemOutCtr(MemOutCtr),
								  .EXTCtr(EXTCtr),
								  .nPCSel(nPCSel)
								  );
								  
	 datapath datapath(.Clk(clk),
	                   .Rst(reset),
						    .RegWrite(RegWrite),
					   	 .RegWriteCtr(RegWriteCtr),
							 .RegSel(RegSel),
							 .ALUSelA(ALUSelA),
							 .ALUSelB(ALUSelB),
							 .ALUCtr(ALUCtr),
						    .MemWrite(MemWrite),
							 .MemWriteCtr(MemWriteCtr),
							 .MemOutCtr(MemOutCtr),
							 .EXTCtr(EXTCtr),
							 .nPCSel(nPCSel),
							 .op(op),
	                   .func(func)
							 );
endmodule
