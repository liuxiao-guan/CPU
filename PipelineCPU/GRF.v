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
    input [4:0] rs,//25:21
    input [4:0] rt,//20:16
    input [4:0] rd,//15:11
    input RegWrite,
    input [31:0] WriteData,
	input [31:0] PC,
    output [31:0] OutA,
    output [31:0] OutB,
	output [4:0] RS,
	output [4:0] RT
    );
	 
	 reg [31:0] RegFile[31:0];
	 reg [4:0] RegRs,RegRt;
	 assign OutA = rs == 5'b0 ? 32'b0 : RegFile[rs];
	 assign OutB = rt == 5'b0 ? 32'b0 : RegFile[rt];
	 assign RS = RegRs;
	 assign RT = RegRt;
	 
	 
	 integer i;
	 
	 always @(posedge Clk) begin
			RegRs <= rs;
			RegRt <= rt;
	 
	     if (Rst == 1'b1) begin
				for (i = 0; i <= 31; i = i + 1) begin
				    RegFile[i] <= 32'b0;
				end
		  end
		  else begin
			  if (RegWrite == 1'b1) begin
						
					if (rd != 5'b0 ) begin
						
						 RegFile[rd] <= WriteData;
						 $display("@%4h: $%d <= %h", PC, rd, WriteData);
					end
					//if (rt != 5'b0) begin
					//	 RegFile[rt] <= WriteData;
					//	 $display("@%h: $%d <= %h", PC, rt, WriteData);
					//end
					
			  end
		  end
	 end

endmodule
