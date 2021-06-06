`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:16:43 11/29/2017 
// Design Name: 
// Module Name:    datapath 
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
module datapath(
    input Clk,
    input Rst,
    input RegWrite,
    input [1:0] RegWriteCtr,
    input [1:0] RegSel,
    input ALUSelA,
    input ALUSelB,
    input [3:0] ALUCtr,
    input MemWrite,
    input [1:0] MemWriteCtr,
    input [2:0] MemOutCtr,
    input [1:0] EXTCtr,
    input [2:0] nPCSel,
    output [5:0] op,
    output [5:0] func
    );
	 
	 //IFU
	 wire [31:0] nPC, PC, Instr;
	 
	 //GRF
	 wire [31:0] WriteData, RegOutA, RegOutB;
	 wire [4:0] rd;
	 
	 //ALU
	 wire [31:0] ALUInA, ALUInB, ALUOut;
	 wire ALUZero;
	 
	 //EXT
	 wire [31:0] EXTOut;
	 
	 //DM
	 wire [31:0] DMOut;
	 
	 //datapath
	 assign op = Instr[31:26];
	 assign func = Instr[5:0];
	 
	 //IFU
	 MUX5to1#(.DATABIT(32)
				)
	 nPCSelMUX(.Sel(nPCSel),
	           .Input0(PC + 32'd4),
				  .Input1(ALUZero == 1'b0 ? PC + 32'd4 : PC + 32'd4 + {{14{Instr[15]}}, Instr[15:0], 2'b00}),//beq
				  .Input2({PC[31:28], Instr[25:0], 2'b00}),//j jal
				  .Input3(ALUOut),//jr jalr
				  .Input4(ALUZero != 1'b0 ? PC + 32'd4 : PC + 32'd4 + {{14{Instr[15]}}, Instr[15:0], 2'b00}),// bne
				  .Out(nPC)
				  );
	 
	 PC pc(.Clk(Clk),
	       .Rst(Rst),
			 .nPC(nPC),
			 .PCOut(PC)
			 );
			 
	 IM im(.PC(PC[11:2]),
	       .Instr(Instr)
			 );
	 
	 //GRF
	 MUX3to1#(.DATABIT(5)
	         )
	 RegSelMUX(.Sel(RegSel),
	           .Input0(Instr[20:16]),
				  .Input1(Instr[15:11]),
				  .Input2(5'h1f),
				  .Out(rd)
				  );
	 
	 MUX3to1#(.DATABIT(32)
	         )
	 RegWriteCtrMUX(.Sel(RegWriteCtr),
	                .Input0(ALUOut),//00
						 .Input1(DMOut),//01
						 .Input2(PC + 32'd4),//10
						 .Out(WriteData)
						 );
						 
	 GRF grf(.Clk(Clk),
	         .Rst(Rst),
				.rs(Instr[25:21]),
				.rt(Instr[20:16]),
				.rd(rd),
				.RegWrite(RegWrite),
				.WriteData(WriteData),
				.PC(PC),
				.OutA(RegOutA),
				.OutB(RegOutB)
				);
	
	 //ALU
	 MUX2to1#(.DATABIT(32)
	         )
	 ALUSelAMUX(.Sel(ALUSelA),
	            .Input0(RegOutA),
					.Input1({27'b0, Instr[10:6]}),
					.Out(ALUInA)
				   );
	 
	 MUX2to1#(.DATABIT(32)
	         )
	 ALUSelBMUX(.Sel(ALUSelB),
	            .Input0(RegOutB),
					.Input1(EXTOut),
					.Out(ALUInB)
					);
			
	 ALU alu(.A(ALUInA),
	         .B(ALUInB),
				.ALUCtr(ALUCtr),
				.Out(ALUOut),
				.Zero(ALUZero)
				);
	 
	 //EXT
	 EXT ext(.Imm(Instr[15:0]),
	         .EXTCtr(EXTCtr),
				.Out(EXTOut)
				);
	
	 //DM
	 DM DM(.Clk(Clk),
	       .Rst(Rst),
			 .Addr(ALUOut),
			 .MemWrite(MemWrite),
			 .MemWriteCtr(MemWriteCtr),
			 .WriteData(RegOutB),
			 .MemOutCtr(MemOutCtr),
			 .PC(PC),
			 .Out(DMOut)
			 );
endmodule
