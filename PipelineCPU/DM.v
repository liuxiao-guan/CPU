`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:05:27 11/28/2017 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input Clk,
    input Rst,
    input [31:0] Addr,
    input MemWrite,
	input [1:0] MemWriteCtr,
    input [31:0] WriteData,
	input [2:0] MemOutCtr,
	input [31:0] PC,
    output [31:0] Out
    );
	 
	 reg [31:0] OutReg = 32'b0;
	 reg [31:0] DataMem[1023:0];
	 reg [31:0] WriteDataReg = 32'b0;
	 
	 assign Out = OutReg;
	 
	 localparam LH = 3'b001;
	 localparam LB = 3'b010;
	 localparam LHU = 3'b100;
	 localparam LBU = 3'b110;
	
	 localparam SH = 2'b01;
	 localparam SB = 2'b10;
	 
	 integer i;
	 
	 always @* begin
		  case (MemOutCtr)
		   	LB : begin
				    case (Addr[1:0])
						  2'b11 : OutReg <= {{24{DataMem[Addr[11:2]][31]}}, DataMem[Addr[11:2]][31:24]};
						  2'b10 : OutReg <= {{24{DataMem[Addr[11:2]][23]}}, DataMem[Addr[11:2]][23:16]};
						  2'b01 : OutReg <= {{24{DataMem[Addr[11:2]][15]}}, DataMem[Addr[11:2]][15:8]};
					  	  default : OutReg <= {{24{DataMem[Addr[11:2]][7]}}, DataMem[Addr[11:2]][7:0]};
				    endcase
			   end
			   
			LH : begin
					case (Addr[1])
							1'b1 : OutReg <= {{16{DataMem[Addr[11:2]][31]}}, DataMem[Addr[11:2]][31:16]};
					    	default : OutReg <= {{16{DataMem[Addr[11:2]][15]}}, DataMem[Addr[11:2]][15:0]};
				    endcase
			   end
			LBU : begin 
					case (Addr[1:0])
						  2'b11 : OutReg <= {{24'b0}, DataMem[Addr[11:2]][31:24]};
						  2'b10 : OutReg <= {{24'b0}, DataMem[Addr[11:2]][23:16]};
						  2'b01 : OutReg <= {{24'b0}, DataMem[Addr[11:2]][15:8]};
					  	  default : OutReg <= {{24'b0}, DataMem[Addr[11:2]][7:0]};
				    endcase
			   end
			LHU : begin
					case (Addr[1])
							1'b1 : OutReg <= {16'b0, DataMem[Addr[11:2]][31:16]};
					    	default : OutReg <= {16'b0, DataMem[Addr[11:2]][15:0]};
				    endcase
			   end
			default/*LW*/ : OutReg <= DataMem[Addr[11:2]];
		  endcase
    end
	 
	 always @* begin
		  case (MemWriteCtr)
			   SB : begin
					 case (Addr[1:0])
						  2'b11 : WriteDataReg <= {WriteData[7:0], DataMem[Addr[11:2]][23:16], DataMem[Addr[11:2]][15:8], DataMem[Addr[11:2]][7:0]};
						  2'b10 : WriteDataReg <= {DataMem[Addr[11:2]][31:24], WriteData[7:0], DataMem[Addr[11:2]][15:8], DataMem[Addr[11:2]][7:0]};
						  2'b01 : WriteDataReg <= {DataMem[Addr[11:2]][31:24], DataMem[Addr[11:2]][23:16], WriteData[7:0], DataMem[Addr[11:2]][7:0]};
						  default : WriteDataReg <= {DataMem[Addr[11:2]][31:24], DataMem[Addr[11:2]][23:16], DataMem[Addr[11:2]][15:8], WriteData[7:0]};
			 	 	 endcase
			   end
			   SH : begin
				 	 case (Addr[1])
						  1'b1 : WriteDataReg <= {WriteData[15:0], DataMem[Addr[11:2]][15:0]};
						  default : WriteDataReg <= {DataMem[Addr[11:2]][31:16], WriteData[15:0]};
					 endcase
			   end
			   default /*SW*/ : begin
					 WriteDataReg <= WriteData;
			   end
		  endcase
	 end
	
	
	 always @(posedge Clk) begin
	     if (Rst == 1'b1) begin
				for (i = 0; i <= 1023; i = i + 1) begin
				    DataMem[i] <= 32'b0;
				end
		  end
		  else begin
				if (MemWrite == 1'b1) begin
				    DataMem[Addr[11:2]] <= WriteDataReg;
					//写入的主要有SW,SB,SH
					 if (MemWriteCtr == 2'b00) begin
					     $display("@%4h: *%h <= %h", PC, Addr, WriteData);
					 end
					 else if (MemWriteCtr == 2'b01) begin
					     $display("@%4h: *%h <= %h", PC, Addr, WriteData[15:0]);
					 end
					 else if (MemWriteCtr == 2'b10) begin
					     $display("@%4h: *%h <= %h", PC, Addr, WriteData[7:0]);
					 end
				end
		  end
	 end
endmodule
