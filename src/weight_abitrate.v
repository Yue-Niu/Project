//这个模块是在角度预测和Planar预测中的加权系数中做选择
module weight_abitrate
(
	input	angle_or_planar,
	
	input [7:0] weight11_angle,
	input [7:0] weight12_angle,
	input [7:0] weight13_angle,
	input [7:0] weight14_angle,
	input [7:0] weight21_angle,
	input [7:0] weight22_angle,
	input [7:0] weight23_angle,
	input [7:0] weight24_angle,
	input [7:0] weight31_angle,
	input [7:0] weight32_angle,
	input [7:0] weight33_angle,
	input [7:0] weight34_angle,
	input [7:0] weight41_angle,
	input [7:0] weight42_angle,
	input [7:0] weight43_angle,
	input [7:0] weight44_angle,
	
	input [5:0] X,
	input [5:0] Y,
	
	output reg[7:0]	weight1_11,
	output reg[7:0]	weight1_12,
	output reg[7:0]	weight1_13,
	output reg[7:0]	weight1_14,
	output reg[7:0]	weight1_21,
	output reg[7:0]	weight1_22,
	output reg[7:0]	weight1_23,
	output reg[7:0]	weight1_24,
	output reg[7:0]	weight1_31,
	output reg[7:0]	weight1_32,
	output reg[7:0]	weight1_33,
	output reg[7:0]	weight1_34,
	output reg[7:0]	weight1_41,
	output reg[7:0]	weight1_42,
	output reg[7:0]	weight1_43,
	output reg[7:0]	weight1_44,
	
	output reg[7:0]	weight2_11,
	output reg[7:0]	weight2_12,
	output reg[7:0]	weight2_13,
	output reg[7:0]	weight2_14,
	output reg[7:0]	weight2_21,
	output reg[7:0]	weight2_22,
	output reg[7:0]	weight2_23,
	output reg[7:0]	weight2_24,
	output reg[7:0]	weight2_31,
	output reg[7:0]	weight2_32,
	output reg[7:0]	weight2_33,
	output reg[7:0]	weight2_34,
	output reg[7:0]	weight2_41,
	output reg[7:0]	weight2_42,
	output reg[7:0]	weight2_43,
	output reg[7:0]	weight2_44
);

	always @(angle_or_planar or X or Y or
				weight11_angle or weight12_angle or weight13_angle or weight14_angle or
				weight21_angle or weight22_angle or weight23_angle or weight24_angle or 
				weight31_angle or weight32_angle or weight33_angle or weight34_angle or
				weight41_angle or weight42_angle or weight43_angle or weight44_angle)
	begin
		if(angle_or_planar==1'b1)
		begin
			weight1_11 <= weight11_angle;
			weight2_11 <= 8'd32-weight11_angle;
			weight1_12 <= weight12_angle;
			weight2_12 <= 8'd32-weight12_angle;
			weight1_13 <= weight13_angle;
			weight2_13 <= 8'd32-weight13_angle;
			weight1_14 <= weight14_angle;
			weight2_14 <= 8'd32-weight14_angle;
			
			weight1_21 <= weight21_angle;
			weight2_21 <= 8'd32-weight21_angle;
			weight1_22 <= weight22_angle;
			weight2_22 <= 8'd32-weight22_angle;
			weight1_23 <= weight23_angle;
			weight2_23 <= 8'd32-weight23_angle;
			weight1_24 <= weight24_angle;
			weight2_24 <= 8'd32-weight24_angle;
			
			weight1_31 <= weight21_angle;
			weight2_31 <= 8'd32-weight21_angle;
			weight1_32 <= weight22_angle;
			weight2_32 <= 8'd32-weight22_angle;
			weight1_33 <= weight23_angle;
			weight2_33 <= 8'd32-weight23_angle;
			weight1_34 <= weight24_angle;
			weight2_34 <= 8'd32-weight24_angle;
			
			weight1_41 <= weight21_angle;
			weight2_41 <= 8'd32-weight21_angle;
			weight1_42 <= weight22_angle;
			weight2_42 <= 8'd32-weight22_angle;
			weight1_43 <= weight23_angle;
			weight2_43 <= 8'd32-weight23_angle;
			weight1_44 <= weight24_angle;
			weight2_44 <= 8'd32-weight24_angle;
		end
		else
		begin
			weight1_11 <= {2'd0,X} + 8'd1;
			weight2_11 <= {2'd0,Y} + 8'd1;
			weight1_12 <= {2'd0,X} + 8'd2;
			weight2_12 <= {2'd0,Y} + 8'd1;
			weight1_13 <= {2'd0,X} + 8'd3;
			weight2_13 <= {2'd0,Y} + 8'd1;
			weight1_14 <= {2'd0,X} + 8'd4;
			weight2_14 <= {2'd0,Y} + 8'd1;
			
			weight1_21 <= {2'd0,X} + 8'd1;
			weight2_21 <= {2'd0,Y} + 8'd2;
			weight1_22 <= {2'd0,X} + 8'd2;
			weight2_22 <= {2'd0,Y} + 8'd2;
			weight1_23 <= {2'd0,X} + 8'd3;
			weight2_23 <= {2'd0,Y} + 8'd2;
			weight1_24 <= {2'd0,X} + 8'd4;
			weight2_24 <= {2'd0,Y} + 8'd2;
			
			weight1_31 <= {2'd0,X} + 8'd2;
			weight2_31 <= {2'd0,Y} + 8'd3;
			weight1_32 <= {2'd0,X} + 8'd2;
			weight2_32 <= {2'd0,Y} + 8'd3;
			weight1_33 <= {2'd0,X} + 8'd3;
			weight2_33 <= {2'd0,Y} + 8'd3;
			weight1_34 <= {2'd0,X} + 8'd4;
			weight2_34 <= {2'd0,Y} + 8'd3;
			
			weight1_41 <= {2'd0,X} + 8'd1;
			weight2_41 <= {2'd0,Y} + 8'd4;
			weight1_42 <= {2'd0,X} + 8'd2;
			weight2_42 <= {2'd0,Y} + 8'd4;
			weight1_43 <= {2'd0,X} + 8'd3;
			weight2_43 <= {2'd0,Y} + 8'd4;
			weight1_44 <= {2'd0,X} + 8'd4;
			weight2_44 <= {2'd0,Y} + 8'd4;
		end
	end
	
endmodule
