// 这个模块主要是对选择出来的参考像素进行滤波
module REF_FILTER
(
	input		CLK1,
	input 	filter_flag,
	
	input	[7:0]	REF_TOP0,
	input	[7:0]	REF_TOP1,
	input	[7:0]	REF_TOP2,
	input	[7:0]	REF_TOP3,
	input	[7:0]	REF_TOP4,
	input	[7:0]	REF_TOP5,
	input	[7:0]	REF_TOP6,
	input	[7:0]	REF_TOP7,
	
	input [7:0] REF_LEFT0,
	input [7:0] REF_LEFT1,
	input [7:0] REF_LEFT2,
	input [7:0] REF_LEFT3,
	input [7:0] REF_LEFT4,
	input [7:0] REF_LEFT5,
	input [7:0] REF_LEFT6,
	input [7:0] REF_LEFT7,
	
	output [7:0]	REF_TOP_F0,
	output [7:0]	REF_TOP_F1,
	output [7:0]	REF_TOP_F2,
	output [7:0]	REF_TOP_F3,
	output [7:0]	REF_TOP_F4,
	output [7:0]	REF_TOP_F5,
	output [7:0]	REF_TOP_F6,
	output [7:0]	REF_TOP_F7,
	output [7:0]	REF_LEFT_F0,
	output [7:0]	REF_LEFT_F1,
	output [7:0]	REF_LEFT_F2,
	output [7:0]	REF_LEFT_F3,
	output [7:0]	REF_LEFT_F4,
	output [7:0]	REF_LEFT_F5,
	output [7:0]	REF_LEFT_F6,
	output [7:0]	REF_LEFT_F7
);

	//Combine pixels
	wire [9:0]	reff[0:15];
	assign reff[0] = {2'b00,REF_TOP7};
	assign reff[1] = {2'b00,REF_TOP6};
	assign reff[2] = {2'b00,REF_TOP5};
	assign reff[3] = {2'b00,REF_TOP4};
	assign reff[4] = {2'b00,REF_TOP3};
	assign reff[5] = {2'b00,REF_TOP2};
	assign reff[6] = {2'b00,REF_TOP1};
	assign reff[7] = {2'b00,REF_TOP0};
	assign reff[8] = {2'b00,REF_LEFT0};
	assign reff[9] = {2'b00,REF_LEFT1};
	assign reff[10] = {2'b00,REF_LEFT2};
	assign reff[11] = {2'b00,REF_LEFT3};
	assign reff[12] = {2'b00,REF_LEFT4};
	assign reff[13] = {2'b00,REF_LEFT5};
	assign reff[14] = {2'b00,REF_LEFT6};
	assign reff[15] = {2'b00,REF_LEFT7};
	
	//Filterring
	reg [9:0] REF_FILT[0:15];
	reg [9:0] REF_FILT1[0:15];
	reg [7:0] ref_left_f[0:7];
	reg [7:0] ref_top_f[0:7];
	reg [7:0] ref_top_uf[0:7];
	reg [7:0] ref_left_uf[0:7];
	integer i;
	
	always @(posedge CLK1)
	begin
		REF_FILT[0] = reff[0];
		REF_FILT[15] = reff[15];
		REF_FILT1[0] = reff[0];
		REF_FILT1[15] = reff[15];
		for(i=1;i<15;i=i+1)
		begin:reff_filtering
			REF_FILT[i] = (reff[i-1] + reff[i]+reff[i] + reff[i+1] + 10'd2);
			REF_FILT1[i] = REF_FILT[i]>>2;
		end
		
		for(i=0;i<8;i=i+1)
		begin:ref_top_output
			ref_top_f[i] = REF_FILT1[7-i][7:0];
			ref_top_uf[i] = reff[7-i][7:0];
		end
		
		for(i=0;i<8;i=i+1)
		begin:ref_left_output
			ref_left_f[i] = REF_FILT1[8+i][7:0];
			ref_left_uf[i] = reff[8+i][7:0];
		end
	end
	
	assign REF_TOP_F0 = filter_flag==1'b1 ? ref_top_f[0] : ref_top_uf[0];
	assign REF_TOP_F1 = filter_flag==1'b1 ? ref_top_f[1] : ref_top_uf[1];
	assign REF_TOP_F2 = filter_flag==1'b1 ? ref_top_f[2] : ref_top_uf[2];
	assign REF_TOP_F3 = filter_flag==1'b1 ? ref_top_f[3] : ref_top_uf[3];
	assign REF_TOP_F4 = filter_flag==1'b1 ? ref_top_f[4] : ref_top_uf[4];
	assign REF_TOP_F5 = filter_flag==1'b1 ? ref_top_f[5] : ref_top_uf[5];
	assign REF_TOP_F6 = filter_flag==1'b1 ? ref_top_f[6] : ref_top_uf[6];
	assign REF_TOP_F7 = filter_flag==1'b1 ? ref_top_f[7] : ref_top_uf[7];
	
	assign REF_LEFT_F0 = filter_flag==1'b1 ? ref_left_f[0] : ref_left_uf[0];
	assign REF_LEFT_F1 = filter_flag==1'b1 ? ref_left_f[1] : ref_left_uf[1];
	assign REF_LEFT_F2 = filter_flag==1'b1 ? ref_left_f[2] : ref_left_uf[2];
	assign REF_LEFT_F3 = filter_flag==1'b1 ? ref_left_f[3] : ref_left_uf[3];
	assign REF_LEFT_F4 = filter_flag==1'b1 ? ref_left_f[4] : ref_left_uf[4];
	assign REF_LEFT_F5 = filter_flag==1'b1 ? ref_left_f[5] : ref_left_uf[5];
	assign REF_LEFT_F6 = filter_flag==1'b1 ? ref_left_f[6] : ref_left_uf[6];
	assign REF_LEFT_F7 = filter_flag==1'b1 ? ref_left_f[7] : ref_left_uf[7];
	
	endmodule
	