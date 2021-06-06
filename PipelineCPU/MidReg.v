module MidReg(
	input Clk,
	input Rst,
	input En,//写使能信号
	input stall,
	input [297:0]Input_,
	output  [297:0]Output_
	
	//250+15
	//251+16 = 267
);
reg [297:0]migreg;
assign Output_ = migreg;
	always@(negedge Clk) begin
		
		if(Rst || stall)begin
			migreg<= 298'b0;
		end
		else if(En) begin
			migreg<= Input_;
		end

	end
	
endmodule


//module dff #(parameter WIDTH = 32) ( //Data Flip-Flop 
//    input clk,
//    input en,
//    input rst,
//    input [WIDTH-1:0] datain,
//    output reg [WIDTH-1:0] dataout
//    );
//    always@(posedge clk)
//    begin
//        if(rst)
//            dataout <= 0;
//        else if(en)
//            dataout <= datain;
//    end
//endmodule











