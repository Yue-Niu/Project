//这个模块决定选择角度预测的参考像素还是Planar预测的参考像素
module REF_ABITRATE
(
	input angle_or_planar,
	input [7:0]	REF_TOP0_angle,
	input [7:0]	REF_TOP1_angle,
	input [7:0]	REF_TOP2_angle,
	input [7:0]	REF_TOP3_angle,
	input [7:0]	REF_TOP4_angle,
	input [7:0]	REF_TOP5_angle,
	input [7:0]	REF_TOP6_angle,
	input [7:0]	REF_TOP7_angle,
	
	input [7:0] REF_LEFT0_angle,
	input [7:0] REF_LEFT1_angle,
	input [7:0] REF_LEFT2_angle,
	input [7:0] REF_LEFT3_angle,
	input [7:0] REF_LEFT4_angle,
	input [7:0] REF_LEFT5_angle,
	input [7:0] REF_LEFT6_angle,
	input [7:0] REF_LEFT7_angle,
	
	input [7:0] REF_TOP0_planar,
	input [7:0] REF_TOP1_planar,
	input [7:0] REF_TOP2_planar,
	input [7:0] REF_TOP3_planar,
	input [7:0] REF_TOP4_planar,
	input [7:0] REF_TOP5_planar,
	input [7:0] REF_TOP6_planar,
	input [7:0] REF_TOP7_planar,
	
	input [7:0]	REF_LEFT0_planar,
	input [7:0]	REF_LEFT1_planar,
	input [7:0]	REF_LEFT2_planar,
	input [7:0]	REF_LEFT3_planar,
	input [7:0]	REF_LEFT4_planar,
	input [7:0]	REF_LEFT5_planar,
	input [7:0]	REF_LEFT6_planar,
	input [7:0]	REF_LEFT7_planar,
	
	output reg[7:0] REF_TOP0,
	output reg[7:0] REF_TOP1,
	output reg[7:0] REF_TOP2,
	output reg[7:0] REF_TOP3,
	output reg[7:0] REF_TOP4,
	output reg[7:0] REF_TOP5,
	output reg[7:0] REF_TOP6,
	output reg[7:0] REF_TOP7,
	
	output reg[7:0] REF_LEFT0,
	output reg[7:0] REF_LEFT1,
	output reg[7:0] REF_LEFT2,
	output reg[7:0] REF_LEFT3,
	output reg[7:0] REF_LEFT4,
	output reg[7:0] REF_LEFT5,
	output reg[7:0] REF_LEFT6,
	output reg[7:0] REF_LEFT7
);

	always @(angle_or_planar or
				REF_TOP0_angle or REF_TOP1_angle or REF_TOP2_angle or REF_TOP3_angle or 
				REF_TOP4_angle or REF_TOP5_angle or REF_TOP6_angle or REF_TOP7_angle or 
				REF_LEFT0_angle or REF_LEFT1_angle or REF_LEFT2_angle or REF_LEFT3_angle or 
				REF_LEFT4_angle or REF_LEFT5_angle or REF_LEFT6_angle or REF_LEFT7_angle or 
				REF_TOP0_planar or REF_TOP1_planar or REF_TOP2_planar or REF_TOP3_planar or 
				REF_TOP4_planar or REF_TOP5_planar or REF_TOP6_planar or REF_TOP7_planar or 
				REF_LEFT0_planar or REF_LEFT1_planar or REF_LEFT2_planar or REF_LEFT3_planar or 
				REF_LEFT4_planar or REF_LEFT5_planar or REF_LEFT6_planar or REF_LEFT7_planar)
	begin
		if(angle_or_planar==1'b1)
		begin
			REF_TOP0 <= REF_TOP0_angle;
			REF_TOP1 <= REF_TOP1_angle;
			REF_TOP2 <= REF_TOP2_angle;
			REF_TOP3 <= REF_TOP3_angle;
			REF_TOP4 <= REF_TOP4_angle;
			REF_TOP5 <= REF_TOP5_angle;
			REF_TOP6 <= REF_TOP6_angle;
			REF_TOP7 <= REF_TOP7_angle;
			
			
			REF_LEFT0 <= REF_LEFT0_angle;
			REF_LEFT1 <= REF_LEFT1_angle;
			REF_LEFT2 <= REF_LEFT2_angle;
			REF_LEFT3 <= REF_LEFT3_angle;
			REF_LEFT4 <= REF_LEFT4_angle;
			REF_LEFT5 <= REF_LEFT5_angle;
			REF_LEFT6 <= REF_LEFT6_angle;
			REF_LEFT7 <= REF_LEFT7_angle;	
		end
		else
		begin
			REF_TOP0 <= REF_TOP0_planar;
			REF_TOP1 <= REF_TOP1_planar;
			REF_TOP2 <= REF_TOP2_planar;
			REF_TOP3 <= REF_TOP3_planar;
			REF_TOP4 <= REF_TOP4_planar;
			REF_TOP5 <= REF_TOP5_planar;
			REF_TOP6 <= REF_TOP6_planar;
			REF_TOP7 <= REF_TOP7_planar;
			
			REF_LEFT0 <= REF_LEFT0_planar;
			REF_LEFT1 <= REF_LEFT1_planar;
			REF_LEFT2 <= REF_LEFT2_planar;
			REF_LEFT3 <= REF_LEFT3_planar;
			REF_LEFT4 <= REF_LEFT4_planar;
			REF_LEFT5 <= REF_LEFT5_planar;
			REF_LEFT6 <= REF_LEFT6_planar;
			REF_LEFT7 <= REF_LEFT7_planar;
		end
	end
endmodule
