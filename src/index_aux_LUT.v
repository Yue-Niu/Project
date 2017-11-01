// This is a module for index auxiliary LUT
module index_aux_LUT
(
	input				clk,
	input				angle_or_planar,
	input [8:0]		address,
	
	output [7:0]	LUT_out1,
	output [7:0]	LUT_out2,
	output [7:0]	LUT_out3,
	output [7:0]	LUT_out4
);

	index_aux1_LUT index_aux1(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
		
		.q(LUT_out1)
		);
		
	index_aux2_LUT index_aux2(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
		
		.q(LUT_out2)
		);
		
	index_aux3_LUT index_aux3(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
		
		.q(LUT_out3)
		);
		
	index_aux4_LUT index_aux4(
		.clock(clk),
		.rden(angle_or_planar),
		.address(address),
		
		.q(LUT_out4)
		);
		
endmodule