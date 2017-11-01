// This is a module for weight LUT
module weight_LUT
(
	input				clk,
	input 			vh_i,
	input				angle_or_planar,
	input [8:0]		address,
	
	output [7:0]	WEIGHT11,
	output [7:0]	WEIGHT12,
	output [7:0]	WEIGHT13,
	output [7:0]	WEIGHT14,
	output [7:0]	WEIGHT21,
	output [7:0]	WEIGHT22,
	output [7:0]	WEIGHT23,
	output [7:0]	WEIGHT24,
	output [7:0]	WEIGHT31,
	output [7:0]	WEIGHT32,
	output [7:0]	WEIGHT33,
	output [7:0]	WEIGHT34,
	output [7:0]	WEIGHT41,
	output [7:0]	WEIGHT42,
	output [7:0]	WEIGHT43,
	output [7:0]	WEIGHT44
);

	wire [7:0] LUT_out1,LUT_out2,LUT_out3,LUT_out4;
	
	weight1_LUT weight1(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
		
		.q(LUT_out1)
		);
		
	weight2_LUT weight2(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
		
		.q(LUT_out2)
		);
		
	weight3_LUT weight3(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
		
		.q(LUT_out3)
		);
		
	weight4_LUT weight4(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
		
		.q(LUT_out4)
		);
	
	assign WEIGHT11 = LUT_out1;
	assign WEIGHT12 = vh_i==1'b1 ? LUT_out1 : LUT_out2;
	assign WEIGHT13 = vh_i==1'b1 ? LUT_out1 : LUT_out2;
	assign WEIGHT14 = vh_i==1'b1 ? LUT_out1 : LUT_out2;
	
	assign WEIGHT21 = vh_i==1'b1 ? LUT_out2 : LUT_out1;
	assign WEIGHT22 = LUT_out2;
	assign WEIGHT23 = vh_i==1'b1 ? LUT_out2 : LUT_out3;
	assign WEIGHT24 = vh_i==1'b1 ? LUT_out2 : LUT_out4;
	
	assign WEIGHT31 = vh_i==1'b1 ? LUT_out3 : LUT_out1;
	assign WEIGHT32 = vh_i==1'b1 ? LUT_out3 : LUT_out2;
	assign WEIGHT33 = LUT_out3;
	assign WEIGHT34 = vh_i==1'b1 ? LUT_out3 : LUT_out4;
	
	assign WEIGHT41 = vh_i==1'b1 ? LUT_out4 : LUT_out1;
	assign WEIGHT42 = vh_i==1'b1 ? LUT_out4 : LUT_out2;
	assign WEIGHT43 = vh_i==1'b1 ? LUT_out4 : LUT_out3;
	assign WEIGHT44 = LUT_out4;
	
endmodule
