`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:20:59 11/28/2017 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
    input [5:0] op,
    input [5:0] func,
    output RegWrite,
    output [1:0] RegWriteCtr,
    output [1:0] RegSel,
    output ALUSelA,
    output ALUSelB,
    output [3:0] ALUCtr,
    output MemWrite,
	output [1:0] MemWriteCtr,
    output [2:0] MemOutCtr,
    output [1:0] EXTCtr,
    output [2:0] nPCSel
    );
	 
	wire RType = op == 6'b000000;
	wire ADDU = RType && func == 6'b100001;
	wire SUBU = RType && func == 6'b100011;
	wire ORI = op == 6'b001101;
	wire LW = op == 6'b100011;
	wire LH = op == 6'b100001;
	wire LB = op == 6'b100000;
	wire SW = op == 6'b101011;
	wire SH = op == 6'b101001;
	wire SB = op == 6'b101000;
	wire BEQ = op == 6'b000100;
	wire LUI = op == 6'b001111;
    wire JAL = op == 6'b000011;
    wire JR = RType && func == 6'b001000;
    wire SLL = RType && func == 6'b000000;
	wire SLT = RType && func == 6'b101010;
	 //要增加的
	wire ADD = RType && func == 6'b100000;
	wire SUB = RType && func == 6'b100010;
	wire AND = RType && func == 6'b100100;
	wire OR = RType && func == 6'b100101;
	wire SLTU = RType && func == 6'b101011;
	wire ADDI = op == 6'b001000;
	wire J = op == 6'b000010;
	wire NOR = RType && func == 6'b100111;
	wire SLTI = op == 6'b001010;
	wire BNE = op == 6'b000101;
	wire ANDI = op == 6'b001100;
	wire SRL =  RType && func == 6'b000010;
	wire SLLV =  RType && func == 6'b000100;
	wire SRLV =  RType && func == 6'b000110;
	wire JALR = RType && func == 6'b001001;
	wire LBU = op == 6'b100100;
	wire LHU = op == 6'b100101;
	wire XOR = RType && func == 6'b100110;
	wire SRA = RType && func == 6'b000011;
	wire SRAV =  RType && func == 6'b000111;
	
	 
	 
	 
	 //当前的指令是否要写寄存器
	assign RegWrite = ADDU || SUBU || ORI || LW || LH || LB || LUI || JAL || SLL || SLT 
	|| ADD || SUB || AND || OR || SLTU || ADDI || NOR || SLTI || BNE || ANDI || SRL || SRLV || SLLV || JALR || LBU || LHU || XOR || SRA || SRAV ;
	//对于要写寄存器的指令, 其结果是从哪个部件读取的
	assign RegWriteCtr = {JAL || JALR , LW || LH || LB || LBU || LHU };
	//对于要写寄存器的指令, 其结果是写到指令的哪一段表示的寄存器号
	assign RegSel = {JAL, ADDU || SUBU || SLL || SLT 
	|| ADD || SUB || AND || OR || SLTU || NOR || SRL || SLLV || SRLV || XOR || SRA || SRAV};
	//ALU操作数A的来源 
	assign ALUSelA = SLL || SRA || SRL;
	//ALU操作数B的来源
	assign ALUSelB = ORI || LW || LH || LB || SW || SH || SB || LUI || ADDI || J || SLTI || BNE || ANDI || LBU || LHU;
	
	
	//对需要用到 ALU 的指令, 要进行什么运算
	//assign ALUCtr = {SLL, ORI || LUI || JR || SLT, SUBU || BEQ || SLT};
	assign ALUCtr = {SLTU || SLTI || SRL||SRLV||SLL||SLLV||SRA ||SRAV||SLT,
	ORI||AND||OR||NOR||ANDI||SRL||SRLV||SLL ||JR || XOR||SRA||LUI||JR,
	NOR|| XOR||SRA||SRAV||SRLV||SLLV,
	SUBU || ORI||BEQ || SUB||OR||SRL||JR|| XOR||SRA||SRAV||LUI||JR||SLTU || BNE};
	//当前的指令是否要写内存地址
	assign MemWrite = SW || SH || SB;
	//对于要写内存地址的指令, 要写值的哪一部分
	assign MemWriteCtr = {SB, SH};
	//对于要从内存中输出结果，输出哪一部分
	assign MemOutCtr = {LHU||LBU,LB||LBU, LH};
	// EXTCtr: 16位立即数扩展成32位的方式
	assign EXTCtr = {LUI, ORI || ANDI};
	//nPCSel: 下一个pc地址从哪里来
	assign nPCSel = {BNE,JAL || JR || J||JALR, BEQ || JR || JALR};
	
endmodule
