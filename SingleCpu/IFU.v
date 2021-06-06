`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:02:39 11/28/2017 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input Clk,
    input Rst,
    input [31:0] nPC,
    output [31:0] PCOut
    );
	 
	 	 
	 reg [31:0] PC = 32'h3000;
	 assign PCOut = PC;

	 
	 always @(posedge Clk) begin
        if (Rst == 1'b1) begin
		      PC <= 32'h3000;
		  end
		  else begin
		      PC <= nPC;
		  end
	 end
endmodule

module IM(
    input [11:2] PC,
	output [31:0] Instr
	 );
	 
	 reg [31:0] InstrMem[1023:0];
	 
	 assign Instr = InstrMem[PC[11:2]];
	 
	 initial begin
	     
		  $readmemh("mipstestloopjal_sim.dat", InstrMem);
		  $readmemh("excode.txt", InstrMem);
	 end
endmodule
