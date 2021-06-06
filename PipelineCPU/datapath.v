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
//注：添加了writedata 但是让它仅在ID阶段传递 以及增加了zero
//////////////////////////////////////////////////////////////////////////////////
module datapath(
    input Clk,
    input Rst,
	//input En,
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
	 wire [31:0] ALUInA, ALUInB, ALUOut,SdALUInA,SdALUInB;
	 wire ALUZero;
	 
	 //EXT
	 wire [31:0] EXTOut;
	 
	 //DM
	 wire [31:0] DMOut;
	 
	 
	 //MidReg

	 wire [31:0]If_PC,If_Instr,Id_SignExt,Id_PC,Id_Instr,Id_RegOutA,Id_RegOutB,Id_WriteData,
				Ex_SignExt,Ex_PC,Ex_Instr,Ex_RegOutA,Ex_RegOutB,Ex_ALUOut,Ex_WriteData,Wb_ALUOut,
				Wb_PC,MeM_PC,MeM_Instr,MeM_RegOutB,MeM_ALUOut,MeM_DMOut,Wb_Instr,Wb_DMOut;
	 wire [4:0]Id_rs,Id_rt,Id_rd,Ex_rs,Ex_rt,Ex_rd,MeM_rs,MeM_rt,MeM_rd,Wb_rs,Wb_rt,Wb_rd;
	 wire [3:0] Id_ALUCtr,Ex_ALUCtr;
	 wire [2:0] Id_nPCSel,Id_MemOutCtr,Ex_MemOutCtr,Ex_nPCSel,MeM_MemOutCtr,MeM_nPCSel,Wb_MemOutCtr;
	 wire[1:0]Id_forwardA,Id_forwardB,Id_RegWriteCtr,Id_RegSel,Id_MemWriteCtr,Id_EXTCtr,
			  Ex_forwardA,Ex_forwardB,Ex_RegWriteCtr,Ex_RegSel,Ex_MemWriteCtr,Ex_EXTCtr,
			  MeM_RegWriteCtr,MeM_RegSel,MeM_MemWriteCtr,Wb_RegWriteCtr,Wb_RegSel;
	 wire Id_RegWrite,Id_ALUSelA,Id_ALUSelB,Id_MemWrite,Ex_RegWrite,Ex_ALUSelA,Ex_ALUSelB,
		  Wb_RegWrite,Ex_Zero,MeM_Zero,Ex_ALUZero,MeM_ALUZero,Wb_ALUZero;
	//输出的零信号
	wire [83:0] IfId84;
	wire [149:0] IfId150;
	wire Id_Ex1; 
	wire [63:0] IdEx64;
	wire [67:0] ExMem68;
	wire [31:0] ExMem32_0;
	wire [31:0] ExMem32_1;
	wire [63:0] ExMem64;
	wire [5:0] ExMem6;
	wire [1:0] ExMem2;
	wire [67:0] MemWb68;
	//wire [31:0] MemWb32;
	wire [63:0] MemWb64;
	wire [8:0] MemWb9;
	wire [4:0]MemWb5;
	 
	 //SideWay
	 wire [1:0]forwardA;
	 wire [1:0]forwardB;
	 wire [3:0]MidRegWrite;
	 wire [3:0]Stall;
	 wire Pcen;
	 //LwHazard
	//  wire IdExFlush;
	//  wire IfIdEn;
	//  wire Pcen;
	
	//datapath
	//  assign op = Instr[31:26];
	//  assign func = Instr[5:0];
	 assign op = Id_Instr[31:26];
	 assign func = Id_Instr[5:0];
	 assign Id_rs  = Id_Instr[25:21];
	  assign Id_rt  = Id_Instr[20:16];
	
	//给ID寄存器赋予控制信号
	assign Id_ALUCtr = ALUCtr;
	assign Id_MemOutCtr = MemOutCtr;
	assign Id_nPCSel = nPCSel;
	assign Id_RegWriteCtr = RegWriteCtr;
	assign Id_RegSel = RegSel;
	assign Id_MemWriteCtr= MemWriteCtr;
	assign Id_EXTCtr= EXTCtr;
	assign Id_MemWrite = MemWrite;
	assign Id_RegWrite = RegWrite;
	assign Id_ALUSelA = ALUSelA;
	assign Id_ALUSelB = ALUSelB;
	assign Id_WriteData = 32'b0;
	assign Id_forwardA = 2'b00;
	assign Id_forwardB = 2'b00;
	//assign Id_rs = Instr[25:21];
	//assign Id_rt = Instr[20:16];
	 
	 
	
	//IFU
	MUX5to1#(.DATABIT(32)
				)
	 nPCSelMUX(.Sel(MeM_nPCSel),
	           .Input0(If_PC + 32'd4),
				  .Input1(MeM_ALUZero == 1'b0 ? If_PC + 32'd4 : MeM_PC + 32'd4 + {{14{MeM_Instr[15]}}, MeM_Instr[15:0], 2'b00}),//beq
				  .Input2({MeM_PC[31:28], MeM_Instr[25:0], 2'b00}),// j jal
				  .Input3(MeM_ALUOut),// jr jalr
				  .Input4(MeM_ALUZero != 1'b0 ? If_PC + 32'd4 : MeM_PC + 32'd4 + {{14{MeM_Instr[15]}}, MeM_Instr[15:0], 2'b00}),//bne
				  .Out(nPC)
				  );
	 
	 
	 
	 
	 PC pc(.Clk(Clk),
	       .Rst(Rst),
		   .En(Pcen),
		   //.Pcen(Pcen),
			 .nPC(nPC),//输入的
			 .PCOut(If_PC)
			 );
			 
	 IM im(.PC(If_PC[11:2]),
	       .Instr(If_Instr)
			 );
	
	 
	 //GRF
	 //对于要写寄存器的指令, 其结果是写到指令的哪一段表示的寄存器号
	 MUX3to1#(.DATABIT(5)
	         )
	 RegSelMUX(.Sel(Id_RegSel),
	           .Input0(Id_Instr[20:16]),
				  .Input1(Id_Instr[15:11]),
				  .Input2(5'h1f),
				  .Out(Id_rd)
				  );
	 
	//  MUX3to1#(.DATABIT(32)
	//          )
	//   RegWriteCtrMUX(.Sel(Id_RegWriteCtr),
	//                 .Input0(MeM_ALUOut),
	// 					 .Input1(Wb_DMOut),
	// 					 .Input2(Id_PC + 32'd4),
	// 					 .Out(Id_WriteData)
	// 
	//对于要写寄存器的指令, 其结果是从哪个部件读取的					 );
	MUX3to1#(.DATABIT(32)
	         )
	  RegWriteCtrMUX(.Sel(Wb_RegWriteCtr),
	                .Input0(Wb_ALUOut),
						 .Input1(Wb_DMOut),
						 .Input2(Wb_PC + 32'd4),
						 .Out(WriteData)
						 );
						 
	 GRF grf(.Clk(Clk),
	         .Rst(Rst),
			 .rs(Id_Instr[25:21]),
			 .rt(Id_Instr[20:16]),
			 .rd(Wb_rd),
			 .RegWrite(Wb_RegWrite),
			 .WriteData(WriteData),
			 .PC(Id_PC),
				.OutA(Id_RegOutA),
				.OutB(Id_RegOutB),
				// .RS(Id_rs),
				// .RT(Id_rt)
				.RS(rs),
				.RT(rt)
				);

	 //ALU
	MUX4to1#(.DATABIT(32)
	         )
	SideWayAluA(.Sel(forwardA),
				.Input0(Ex_RegOutA),
				.Input1(Wb_DMOut),
				.Input2(MeM_ALUOut),
				.Input3(Wb_ALUOut),
				.Out(SdALUInA)
	);
MUX4to1#(.DATABIT(32)
	         )
	SideWayAluB(.Sel(forwardB),
				.Input0(Ex_RegOutB),
				.Input1(Wb_DMOut),
				.Input2(MeM_ALUOut),
				.Input3(Wb_ALUOut),
				.Out(SdALUInB)
	); 
	 MUX2to1#(.DATABIT(32)
	         )
	 ALUSelAMUX(.Sel(Ex_ALUSelA),
	            .Input0(SdALUInA),
					.Input1({27'b0, Ex_Instr[10:6]}),
					.Out(ALUInA)
				   );
	 
	 MUX2to1#(.DATABIT(32)
	         )
	 ALUSelBMUX(.Sel(Ex_ALUSelB),
	            .Input0(SdALUInB),
					.Input1(Ex_SignExt),
					.Out(ALUInB)
					);
	//对来源ALU的来源进一步判断 数据冒险

	 ALU alu(.A(ALUInA),
	         .B(ALUInB),
				.ALUCtr(Ex_ALUCtr),
				.Out(Ex_ALUOut),
				.Zero(Ex_ALUZero)
				);

	 
	 //EXT
	 EXT ext(.Imm(Id_Instr[15:0]),
	         .EXTCtr(Id_EXTCtr),
				//.Out(EXTOut)
				.Out(Id_SignExt)
				);
	
	 //DM
	 DM DM(.Clk(Clk),
	       .Rst(Rst),
			 .Addr(MeM_ALUOut),
			 .MemWrite(MeM_MemWrite),
			 .MemWriteCtr(MeM_MemWriteCtr),
			 .WriteData(MeM_RegOutB),
			 .MemOutCtr(MeM_MemOutCtr),
			 .PC(MeM_PC),
			 	.Out(MeM_DMOut)
			 );
			 
	//MidReg	
	



	

MidReg RegIfId(	
				.Clk(Clk),
				.Rst(Rst),//清零信号
				//.En(IfIdEn),//写使能信号
				.En(MidRegWrite[0]),//有待更正
				.stall(Stall[0]),
				//.Input_({{5'b0},{79'b0},{If_PC},{If_Instr},{150'b0}}),//此处应该还要有一个清空信号flush，
				.Input_({5'b0,79'b0,If_PC,If_Instr,150'b0}),
					.Output_({{IfId84},{Id_PC},{Id_Instr},{IfId150}})											//用于控制冒险在将下一条指令的直接清零
					//.Output_({51'b0,Id_nPC,Id_nPC,150'b0})	
					);
MidReg RegIdEx(
				.Clk(Clk),
				.Rst(Rst),
				.En(MidRegWrite[1]),//有待更正
				.stall(Stall[1]),
				.Input_({1'b0,Id_WriteData,Id_forwardA,Id_forwardB,Id_SignExt,Id_rs,Id_rt,Id_rd,Id_PC,Id_Instr,Id_RegOutA,Id_RegOutB,64'b0,
				Id_RegWrite,Id_RegWriteCtr,Id_RegSel,Id_ALUSelA,Id_ALUSelB,Id_ALUCtr,Id_MemWrite,Id_MemWriteCtr,Id_MemOutCtr,Id_EXTCtr,Id_nPCSel}),
					.Output_({{Id_Ex1},{Ex_WriteData},{Ex_forwardA},{Ex_forwardB},{Ex_SignExt},{Ex_rs},{Ex_rt},{Ex_rd},{Ex_PC},{Ex_Instr},{Ex_RegOutA},{Ex_RegOutB},{IdEx64},
				{Ex_RegWrite},{Ex_RegWriteCtr},{Ex_RegSel},{Ex_ALUSelA},{Ex_ALUSelB},{Ex_ALUCtr},{Ex_MemWrite},{Ex_MemWriteCtr},{Ex_MemOutCtr},{Ex_EXTCtr},{Ex_nPCSel}})
				);
MidReg RegExMeM(
				.Clk(Clk),
				.Rst(Rst),
				.En(MidRegWrite[2]),//有待更正
				.stall(Stall[2]),
				.Input_({Ex_ALUZero,68'b0,Ex_rs,Ex_rt,Ex_rd,Ex_PC,Ex_Instr,32'b0,Ex_RegOutB,Ex_ALUOut,32'b0,Ex_RegWrite,Ex_RegWriteCtr,Ex_RegSel,6'b0,Ex_MemWrite,
				Ex_MemWriteCtr,Ex_MemOutCtr,2'b0,Ex_nPCSel}),
					.Output_({{MeM_ALUZero},{ExMem68},{MeM_rs},{MeM_rt},{MeM_rd},{MeM_PC},{MeM_Instr},{ExMem32_0},{MeM_RegOutB},{MeM_ALUOut},{ExMem32_1},{MeM_RegWrite},{MeM_RegWriteCtr},{MeM_RegSel},{ExMem6},{MeM_MemWrite},
					{MeM_MemWriteCtr},{MeM_MemOutCtr},{ExMem2},{MeM_nPCSel}})
				);
MidReg RegMeMWb(
				.Clk(Clk),
				.Rst(Rst),
				.En(MidRegWrite[3]),//有待更正
				.stall(Stall[3]),
				.Input_({MeM_ALUZero,68'b0,MeM_rs,MeM_rt,MeM_rd,MeM_PC,MeM_Instr,64'b0,MeM_ALUOut,MeM_DMOut,MeM_RegWrite,MeM_RegWriteCtr,MeM_RegSel,9'b0,MeM_MemOutCtr,5'b0}
					),
					.Output_({Wb_ALUZero,{MemWb68},{Wb_rs},{Wb_rt},{Wb_rd},{Wb_PC},{Wb_Instr},{MemWb64},{Wb_ALUOut},{Wb_DMOut},{Wb_RegWrite},{Wb_RegWriteCtr},{Wb_RegSel},{MemWb9},{Wb_MemOutCtr},{MemWb5}}
					)
				);
	//SideWay
SideWay sideway(	
				.ExMemRd(MeM_rd),
				.MemWbRd(Wb_rd),
				.ExMemRegWrite(MeM_RegWrite),
				.MemWbRegWrite(Wb_RegWrite),
				.IdExRs(Ex_rs),
				.IdExRt(Ex_rt),
				.EXMeMRegWriteCtr(MeM_RegWriteCtr),
				.MeMWbRegWriteCtr(Wb_RegWriteCtr),
				.ExMemnPCSel(MeM_nPCSel),
				.ExMeMAluZero(MeM_ALUZero),
					.forwardA(forwardA),
					.forwardB(forwardB),
					.MidRegWrite(MidRegWrite),
					.Stall(Stall),
					.Pcen(Pcen)
					);

//	进行对lw的冒险检测 发现控制信号里没有memread 信号

// LwHazard lwhazard(
// 					//.IdExMemRead()
// 					.IdEXMemOutCtr(MeM_MemOutCtr),
// 					.IfIdRs(Ex_rs),
// 					.IfIdRt(Ex_rt),
// 					.IdExRt(MeM_rt),
// 						.Stall(IdExFlush),
// 						.PCen(PCen),
// 						.IfIden(IfIden)
// 					//.IfIdEn()
// 					//.PcEn

// 					);
endmodule
