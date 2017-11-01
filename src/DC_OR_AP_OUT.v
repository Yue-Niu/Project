//下面这个模块是选择DC预测还是角度预测或者PLANAR预测
module DC_OR_AP_OUT
(
	input CLK_LOW,
	input DC_flag,
	
	input [7:0] PRED11_AP,
	input [7:0] PRED12_AP,
	input [7:0] PRED13_AP,
	input [7:0] PRED14_AP,
	input [7:0] PRED21_AP,
	input [7:0] PRED22_AP,
	input [7:0] PRED23_AP,
	input [7:0] PRED24_AP,
	input [7:0] PRED31_AP,
	input [7:0] PRED32_AP,
	input [7:0] PRED33_AP,
	input [7:0] PRED34_AP,
	input [7:0] PRED41_AP,
	input [7:0] PRED42_AP,
	input [7:0] PRED43_AP,
	input [7:0] PRED44_AP,
	
	input [7:0] PRED11_DC,
	input [7:0] PRED12_DC,
	input [7:0] PRED13_DC,
	input [7:0] PRED14_DC,
	input [7:0] PRED21_DC,
	input [7:0] PRED22_DC,
	input [7:0] PRED23_DC,
	input [7:0] PRED24_DC,
	input [7:0] PRED31_DC,
	input [7:0] PRED32_DC,
	input [7:0] PRED33_DC,
	input [7:0] PRED34_DC,
	input [7:0] PRED41_DC,
	input [7:0] PRED42_DC,
	input [7:0] PRED43_DC,
	input [7:0] PRED44_DC,
	
	output reg[7:0] PRED_OUT11,
	output reg[7:0] PRED_OUT12,
	output reg[7:0] PRED_OUT13,
	output reg[7:0] PRED_OUT14,
	output reg[7:0] PRED_OUT21,
	output reg[7:0] PRED_OUT22,
	output reg[7:0] PRED_OUT23,
	output reg[7:0] PRED_OUT24,
	output reg[7:0] PRED_OUT31,
	output reg[7:0] PRED_OUT32,
	output reg[7:0] PRED_OUT33,
	output reg[7:0] PRED_OUT34,
	output reg[7:0] PRED_OUT41,
	output reg[7:0] PRED_OUT42,
	output reg[7:0] PRED_OUT43,
	output reg[7:0] PRED_OUT44
);

	always @(posedge CLK_LOW)
	begin
		if(DC_flag==1'b1)
		begin
			PRED_OUT11 = PRED11_DC;
			PRED_OUT12 = PRED12_DC;
			PRED_OUT13 = PRED13_DC;
			PRED_OUT14 = PRED14_DC;
			PRED_OUT21 = PRED21_DC;
			PRED_OUT22 = PRED22_DC;
			PRED_OUT23 = PRED23_DC;
			PRED_OUT24 = PRED24_DC;
			PRED_OUT31 = PRED31_DC;
			PRED_OUT32 = PRED32_DC;
			PRED_OUT33 = PRED33_DC;
			PRED_OUT34 = PRED34_DC;
			PRED_OUT41 = PRED41_DC;
			PRED_OUT42 = PRED42_DC;
			PRED_OUT43 = PRED43_DC;
			PRED_OUT44 = PRED44_DC;
		end
		else
		begin
			PRED_OUT11 = PRED11_AP;
			PRED_OUT12 = PRED12_AP;
			PRED_OUT13 = PRED13_AP;
			PRED_OUT14 = PRED14_AP;
			PRED_OUT21 = PRED21_AP;
			PRED_OUT22 = PRED22_AP;
			PRED_OUT23 = PRED23_AP;
			PRED_OUT24 = PRED24_AP;
			PRED_OUT31 = PRED31_AP;
			PRED_OUT32 = PRED32_AP;
			PRED_OUT33 = PRED33_AP;
			PRED_OUT34 = PRED34_AP;
			PRED_OUT41 = PRED41_AP;
			PRED_OUT42 = PRED42_AP;
			PRED_OUT43 = PRED43_AP;
			PRED_OUT44 = PRED44_AP;
		end
	end
	
endmodule
