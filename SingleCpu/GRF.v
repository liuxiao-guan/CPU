`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:19:09 11/28/2017 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input Clk,
    input Rst,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] rd,
    input RegWrite,
    input [31:0] WriteData,
	 input [31:0] PC,
    output [31:0] OutA,
    output [31:0] OutB
    );
	 
	 reg [31:0] RegFile[31:1];
	 
	 assign OutA = rs == 5'b0 ? 32'b0 : RegFile[rs];
	 assign OutB = rt == 5'b0 ? 32'b0 : RegFile[rt];
	 
	 integer i;
	 
	 always @(posedge Clk) begin
	     if (Rst == 1'b1) begin
				for (i = 1; i <= 31; i = i + 1) begin
				    RegFile[i] <= 32'b0;
				end
		  end
		  else begin
			  if (RegWrite == 1'b1) begin
						
					//if (rd != 5'b0 ) begin
						 RegFile[rd] <= WriteData;
						 $display("@%4h: $%d <= %h", PC, rd, WriteData);
					//end
					//if (rt != 5'b0) begin
					//	 RegFile[rt] <= WriteData;
					//	 $display("@%4h: $%d <= %h", PC, rt, WriteData);
					//end
					
			  end
		  end
	 end

endmodule
