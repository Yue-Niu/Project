// this is a module for top index LUT
module index_LUT
(
	input				clk,
	input				angle_or_planar,
	input [8:0]		address,
	
	output [7:0]	LUT_out1,
	output [7:0]	LUT_out2,
	output [7:0]	LUT_out3,
	output [7:0]	LUT_out4
);
	
	index1_LUT index1(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
		
		.q(LUT_out1)
		);
		
	index2_LUT index2(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
		
		.q(LUT_out2)
		);
		
	index3_LUT index3(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
		
		.q(LUT_out3)
		);
		
	index4_LUT index4(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
			
		.q(LUT_out4)
		);
endmodule
	