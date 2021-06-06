//实现转发模块
module SideWay(
	input[4:0] ExMemRd,
	input[4:0]MemWbRd,
	input ExMemRegWrite,
	input MemWbRegWrite,
	input [4:0]IdExRs,
	input [4:0]IdExRt,
	input [1:0]EXMeMRegWriteCtr,//判断是不是lw类型指令
	input [1:0]MeMWbRegWriteCtr,
	input [2:0]ExMemnPCSel,//判断是不是跳转类的指令
	input ExMeMAluZero,
	output [1:0]forwardA,
	output [1:0]forwardB,
	output [3:0]MidRegWrite,
	output [3:0]Stall,
	output Pcen
	);
	reg [1:0]fA= 2'b00;
	reg [1:0]fB = 2'b00;
	reg [3:0]midregwrite;
	reg [3:0]stall;
	reg pcen;
	assign forwardA = fA;
	assign forwardB = fB;
	assign MidRegWrite =midregwrite;
	assign Stall = stall;
	assign Pcen = pcen;
	always @(*) begin
		fA <= 2'b00;
		fB <= 2'b00;
		midregwrite <= 4'b1111;
		stall <= 4'b0000;
		pcen <= 1'b1;
		case (ExMemnPCSel)    // 应该把控制冒险放在数据冒险的前面，否则若是load指令，nop不应是全0，但是在最后根据这个case又改回了全0
            3'b001: stall <= (ExMeMAluZero) ? 4'b0110 : 4'b0;
            3'b010: stall <= 4'b0110;//第一个寄存器没被阻塞为了让产生的新PC写入
            3'b011: stall <= 4'b0110;
            3'b100: stall <= (!ExMeMAluZero) ? 4'b0110 : 4'b0;
            default: stall <= 4'b0;
        endcase  // 注意！
		if (ExMemRegWrite != 0 && IdExRs == ExMemRd && ExMemRd != 5'b00000) begin
			if(EXMeMRegWriteCtr == 2'b01)begin //检测到为lw类型
				midregwrite <= 4'b1000;//不允许写，相当于中间插入了一条空指令
				stall <= 4'b0100;//使下一条指令相当于没运行
				pcen <=1'b0;
				
			end
			else begin
				fA <= 2'b10;
			end
			
		end 
		else if (MemWbRegWrite != 1'b0 && IdExRs == MemWbRd && MemWbRd != 5'b00000) begin 
				if(MeMWbRegWriteCtr == 2'b01) begin
					fA <= 2'b01;
				end
				else begin
					fA <= 2'b11;
				end
						
		end

		if (ExMemRegWrite != 0 && IdExRt == ExMemRd && ExMemRd != 5'b00000) begin
			if(EXMeMRegWriteCtr == 2'b01)begin //检测到为lw类型
				midregwrite <= 4'b1000;//不允许写，相当于中间插入了一条空指令
				stall <= 4'b0100;//使下一条指令相当于没运行
				pcen <=1'b0;
			end
			else begin
				fB <= 2'b10;
			end
			
		end 
		else if (MemWbRegWrite != 1'b0 && IdExRt == MemWbRd && MemWbRd != 5'b00000) begin 
				if(MeMWbRegWriteCtr == 2'b01) begin
					fB <= 2'b01;
				end
				else begin
					fB <= 2'b11;
				end
						
		end
	end
	
endmodule