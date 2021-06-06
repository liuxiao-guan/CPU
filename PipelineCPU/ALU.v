`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:55:02 11/28/2017 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUCtr,
    output [31:0] Out,
    output Zero
    );
	 
	 reg [31:0] OutReg = 32'b0;
	 
	 assign Out = OutReg;
	 assign Zero = OutReg == 32'b0;
	 //加, 减, 与, 或, 异或, 或非, 逻辑左移, 逻辑右移, 算术右移, 小于比较, 无符号小于比较
	 //localparam SUB = 3'b001;
	 //localparam OR = 3'b010;
	 //localparam LESS = 3'b011;
	 //localparam LOGICLEFTSHIFT = 3'b100;
	 localparam ADD = 4'b0000;
	 localparam SUB = 4'b0001;
	 
	 
	 localparam AND = 4'b0100;
	 localparam OR = 4'b0101;
	 localparam XOR = 4'b0111;
	 localparam NOR = 4'b0110;
	 
	 localparam LOGICLEFTSHIFT = 4'b1100;
	 localparam LOGICRIGHTSHIFT = 4'b1101;
	 localparam ARITHMETICRIGHTSHIFT = 4'b1111;
	 localparam LOGICLEFTSHIFT1 = 4'b1010;
	 localparam LOGICRIGHTSHIFT1 = 4'b1110;
	 localparam ARITHMETICRIGHTSHIFT1 = 4'b1011;
	 
	 localparam SLT = 4'b1000;
	 localparam SLTU = 4'b1001;
	 
	 always @* begin
	     case (ALUCtr)
				ADD : OutReg <= A + B;
				SUB : OutReg <= A - B;
				
				AND : OutReg <= A & B;
				OR : OutReg <= A | B;
				XOR : OutReg <= A ^ B;
				NOR : OutReg <= ~(A|B);
				
				
				LOGICLEFTSHIFT : OutReg <= B << A;//sll 
				LOGICRIGHTSHIFT : OutReg <= B >> A;//slr
				ARITHMETICRIGHTSHIFT : OutReg <= ($signed(B)) >>> A;//sra
				LOGICLEFTSHIFT1 : OutReg <= B << A[4:0]; //sllv
				LOGICRIGHTSHIFT1 : OutReg <= B >> A[4:0]; //slrv
				ARITHMETICRIGHTSHIFT1 : OutReg <= ($signed(B)) >>> A[4:0];//srav
				
				SLT : OutReg <= $signed(A) < $signed(B);
				default /*SLTU*/ : OutReg <= $unsigned(A) < $unsigned(B);
		      //default /*ADD*/ : OutReg <= A + B;
		  endcase
	 end

endmodule
