`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:24:12 11/28/2017 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
    input [15:0] Imm,
    input [1:0] EXTCtr,
    output [31:0] Out
    );
	 
	 reg [31:0] OutReg = 32'b0;
	 
	 assign Out = OutReg;
	 
	 localparam ZERO = 2'b01;
	 localparam LOW = 2'b10;
	 
	 always @* begin
	     case (EXTCtr)
				LOW : OutReg <= {Imm, 16'b0};
				ZERO : OutReg <= {16'b0, Imm};
		      default /*SIGNED*/ : OutReg <= {{16{Imm[15]}}, Imm};
		  endcase
	 end
endmodule
