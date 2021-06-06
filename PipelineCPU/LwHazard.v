//用于lw冒险的检测  处于ID级 发现没有memread信号所以用memoutctr 代替
//阻塞的方法：保持PC寄存器不变 IF/Id寄存器不变

module LwHazard( 
	//input IdExMemRead;
	input [2:0]IdEXMemOutCtr,
	input[4:0] IfIdRs,
	input[4:0] IfIdRt,
	input [4:0] IdExRt,
	output Stall,
	output PCen,
	output IfIden
	
	);
	reg stall = 1'b0;
	assign Stall = stall;
	assign PCen = ~stall;
	assign IfIden = ~stall;
	always @(*) begin
		if(((IdExRt == IfIdRs) || (IdExRt == IfIdRt)) && IdEXMemOutCtr != 3'b0)
		begin 
			stall <= 1'b1;
			//IfIdEn = ~(IdExFlush);
			//PcEn = ~(IdExFlush);
		end
		
	end
	
endmodule 