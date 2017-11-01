//这个模块相当于Planar预测的滤波模块
module REF_FILTER_planar
(
	input	CLK1,
	
	input [7:0]	REF_TOP0,
	input [7:0]	REF_TOP1,
	input [7:0]	REF_TOP2,
	input [7:0]	REF_TOP3,
	input [7:0]	REF_TOP4,
	input [7:0]	REF_TOP5,
	input [7:0]	REF_TOP6,
	input [7:0]	REF_TOP7,
	
	input [7:0]	REF_LEFT0,
	input [7:0]	REF_LEFT1,
	input [7:0]	REF_LEFT2,
	input [7:0]	REF_LEFT3,
	input [7:0]	REF_LEFT4,
	input [7:0]	REF_LEFT5,
	input [7:0]	REF_LEFT6,
	input [7:0]	REF_LEFT7,
	
	output reg[7:0] REF_TOP_F0,
	output reg[7:0] REF_TOP_F1,
	output reg[7:0] REF_TOP_F2,
	output reg[7:0] REF_TOP_F3,
	output reg[7:0] REF_TOP_F4,
	output reg[7:0] REF_TOP_F5,
	output reg[7:0] REF_TOP_F6,
	output reg[7:0] REF_TOP_F7,
	
	output reg[7:0] REF_LEFT_F0,
	output reg[7:0] REF_LEFT_F1,
	output reg[7:0] REF_LEFT_F2,
	output reg[7:0] REF_LEFT_F3,
	output reg[7:0] REF_LEFT_F4,
	output reg[7:0] REF_LEFT_F5,
	output reg[7:0] REF_LEFT_F6,
	output reg[7:0] REF_LEFT_F7
);

	always @(posedge CLK1)
	begin
		REF_TOP_F0 <= REF_TOP4-REF_TOP0;
		REF_TOP_F1 <= REF_TOP4-REF_TOP1;
		REF_TOP_F2 <= REF_TOP4-REF_TOP2;
		REF_TOP_F3 <= REF_TOP4-REF_TOP3;
		REF_TOP_F4 <= REF_TOP4;
		REF_TOP_F5 <= REF_TOP5;
		REF_TOP_F6 <= REF_TOP6;
		REF_TOP_F7 <= REF_TOP7;
		
		REF_LEFT_F0 <= REF_LEFT4-REF_LEFT0;
		REF_LEFT_F1 <= REF_LEFT4-REF_LEFT1;
		REF_LEFT_F2 <= REF_LEFT4-REF_LEFT2;
		REF_LEFT_F3 <= REF_LEFT4-REF_LEFT3;
		REF_LEFT_F4 <= REF_LEFT4;
		REF_LEFT_F5 <= REF_LEFT5;
		REF_LEFT_F6 <= REF_LEFT6;
		REF_LEFT_F7 <= REF_LEFT7;
	end
	
endmodule
