`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:12:00 11/28/2017 
// Design Name: 
// Module Name:    RegWriteCtrMUX 
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
module MUX2to1
	 #(
	 parameter DATABIT = 32
	 )
	 (
    input Sel,
    input [DATABIT - 1:0] Input0,
    input [DATABIT - 1:0] Input1,
    output [DATABIT - 1:0] Out
    );
	 
	 reg [DATABIT - 1:0] OutReg;
	 
	 assign Out = OutReg;
	 
	 always @* begin
	     case (Sel)
		      1'b1 : OutReg <= Input1;
				default : OutReg <= Input0;
		  endcase
	 end
endmodule

module MUX3to1
	 #(
	 parameter DATABIT = 32
	 )
	 (
    input [1:0] Sel,
    input [DATABIT - 1:0] Input0,
    input [DATABIT - 1:0] Input1,
    input [DATABIT - 1:0] Input2,
    output [DATABIT - 1:0] Out
    );
	 
	 reg [DATABIT - 1:0] OutReg;
	 
	 assign Out = OutReg;
	 
	 always @* begin
	     case (Sel)
		      2'b10 : OutReg <= Input2;
				2'b01 : OutReg <= Input1;
				default : OutReg <= Input0;
		  endcase
	 end
endmodule

module MUX4to1
	 #(
	 parameter DATABIT = 32
	 )
	 (
    input [1:0] Sel,
    input [DATABIT - 1:0] Input0,
    input [DATABIT - 1:0] Input1,
    input [DATABIT - 1:0] Input2,
    input [DATABIT - 1:0] Input3,
    output [DATABIT - 1:0] Out
    );
	 
	 reg [DATABIT - 1:0] OutReg;
	 
	 assign Out = OutReg;
	 
	 always @* begin
	     case (Sel)
		      2'b11 : OutReg <= Input3;
				2'b10 : OutReg <= Input2;
				2'b01 : OutReg <= Input1;
				default : OutReg <= Input0;
		  endcase
	 end
endmodule
module MUX5to1
	 #(
	 parameter DATABIT = 32
	 )
	 (
    input [2:0] Sel,
    input [DATABIT - 1:0] Input0,
    input [DATABIT - 1:0] Input1,
    input [DATABIT - 1:0] Input2,
    input [DATABIT - 1:0] Input3,
	input [DATABIT - 1:0] Input4,
    output [DATABIT - 1:0] Out
    );
	 
	 reg [DATABIT - 1:0] OutReg;
	 
	 assign Out = OutReg;
	 
	 always @* begin
	    case (Sel)
				3'b100 : OutReg <= Input4;//bne
				3'b011: OutReg <= Input3; //jr jalr
				3'b010 : OutReg <= Input2;//j jal
				3'b001: OutReg <= Input1;//beq
				default : OutReg <= Input0;
		endcase
	 end
endmodule