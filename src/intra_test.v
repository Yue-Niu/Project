//This is a test top level module

module intra_test
(
	input 			clk,
	input				rst_n,
	input				vh_i,
	
	input	[2:0]		PU,
	input [5:0]		MODE,
	//input [8:0]		address2,
	
	output 			en_top,
	output			en_left,
	output			complete_flag,
	/*output [7:0]	pred_out11,
	output [7:0]	pred_out12,
	output [7:0]	pred_out13,
	output [7:0]	pred_out14,
	output [7:0]	pred_out21,
	output [7:0]	pred_out22,
	output [7:0]	pred_out23,
	output [7:0]	pred_out24,
	output [7:0]	pred_out31,
	output [7:0]	pred_out32,
	output [7:0]	pred_out33,
	output [7:0]	pred_out34,
	output [7:0]	pred_out41,
	output [7:0]	pred_out42,
	output [7:0]	pred_out43,
	output [7:0]	pred_out44*/
	output oBLANK_n,
	output oHS,
	output oVS,
	output clk_vga,
	output [7:0] b_data,
	output [7:0] g_data,
	output [7:0] r_data
);

	// divide clk to clk1
	wire clk1;
	clk2clk1 clk2clk1_u(
		.clk(clk),
		.rst_n(rst_n),
		
		.clk1(clk1),
		.clk_vga(clk_vga)
		);
		
/*
	下面的程序是角度控制的总体状态机，主要控制读数据地址和一些标志位
*/
	wire filter_flag, negetive_flag,negetive_pred,angle_or_planar,preset_flag;
	wire DC_flag,DCVAL_flag;
	PuMode_Flag PuMode_Flag_u(
		.PU(PU),
		.MODE(MODE),
		
		.filter_flag(filter_flag),
		.negetive_pred(negetive_pred),
		.angle_or_planar(angle_or_planar),
		.DC_flag(DC_flag)
	);
	
	wire [5:0]	X,Y;
	wire [8:0]	address1;
	
	wire [9:0]	MODE1;
	assign MODE1 = MODE-6'd2;
	
	wire complete_flag_angle, complete_flag_planar;
	ANGLE_PRED_CONTROL ANGLE_PRED_CONTROL_u(
		.CLK1(clk1),
		.RST_n(rst_n),
		
		.vh_i(vh_i),
		.PU(PU),
		.MODE({3'd0,MODE1}),
		
		.complete_flag(complete_flag_angle),
		.X(X),
		.Y(Y),
		.ADDR(address1)
	);

	wire [7:0] top_right,bottom_left;
	wire dcval_flag,top_valid,left_valid;
	wire read_ena;
	PLANAR_PRED_CONTROL PLANAR_PRED_CONTROL_u(
		.CLK1(clk1),
		.RST_n(rst_n),
		
		.PU(PU),
		
		.complete_flag(complete_flag_planar),
		.read_ena(read_ena),
		.TOP_RIGHT(top_right),
		.BOTTOM_LEFT(bottom_left),
		.DCVAL_flag(dcval_flag),
		.TOP_VALID(top_valid),
		.LEFT_VALID(left_valid)
		);
	
		
	//internal wire for index_LUT
	wire [7:0] index_LUT_out1, index_LUT_out2, index_LUT_out3, index_LUT_out4;
	index_LUT index_LUT_u(
		.clk(clk1),
		.angle_or_planar(angle_or_planar),
		.address(address1),
		
		.LUT_out1(index_LUT_out1),
		.LUT_out2(index_LUT_out2),
		.LUT_out3(index_LUT_out3),
		.LUT_out4(index_LUT_out4)
		);

/*
	下面是得到PLANAR预测和角度预测的加权系数
*/
	//internal wire for weight LUT
	wire [7:0] weight11,weight12,weight13,weight14,
	           weight21,weight22,weight23,weight24,
				  weight31,weight32,weight33,weight34,
				  weight41,weight42,weight43,weight44;
	wire [7:0] weight1_11,weight1_12,weight1_13,weight1_14,
				  weight1_21,weight1_22,weight1_23,weight1_24,
				  weight1_31,weight1_32,weight1_33,weight1_34,
				  weight1_41,weight1_42,weight1_43,weight1_44;
	wire [7:0] weight2_11,weight2_12,weight2_13,weight2_14,
				  weight2_21,weight2_22,weight2_23,weight2_24,
				  weight2_31,weight2_32,weight2_33,weight2_34,
				  weight2_41,weight2_42,weight2_43,weight2_44;
	weight_LUT weight_LUT_u(
		.clk(clk1),
		.vh_i(vh_i),
		.angle_or_planar(angle_or_planar),
		.address(address1),
		
		.WEIGHT11(weight11),
		.WEIGHT12(weight12),
		.WEIGHT13(weight13),
		.WEIGHT14(weight14),
		.WEIGHT21(weight21),
		.WEIGHT22(weight22),
		.WEIGHT23(weight23),
		.WEIGHT24(weight24),
		.WEIGHT31(weight31),
		.WEIGHT32(weight32),
		.WEIGHT33(weight33),
		.WEIGHT34(weight34),
		.WEIGHT41(weight41),
		.WEIGHT42(weight42),
		.WEIGHT43(weight43),
		.WEIGHT44(weight44)
		);
	
	weight_abitrate weight_abitrate_u(
		.angle_or_planar(angle_or_planar),
		
		.weight11_angle(weight11),
		.weight12_angle(weight12),
		.weight13_angle(weight13),
		.weight14_angle(weight14),
		.weight21_angle(weight21),
		.weight22_angle(weight22),
		.weight23_angle(weight23),
		.weight24_angle(weight24),
		.weight31_angle(weight31),
		.weight32_angle(weight32),
		.weight33_angle(weight33),
		.weight34_angle(weight34),
		.weight41_angle(weight41),
		.weight42_angle(weight42),
		.weight43_angle(weight43),
		.weight44_angle(weight44),
		
		.X(X),
		.Y(Y),
		
		.weight1_11(weight1_11),
		.weight1_12(weight1_12),
		.weight1_13(weight1_13),
		.weight1_14(weight1_14),
		.weight1_21(weight1_21),
		.weight1_22(weight1_22),
		.weight1_23(weight1_23),
		.weight1_24(weight1_24),
		.weight1_31(weight1_31),
		.weight1_32(weight1_32),
		.weight1_33(weight1_33),
		.weight1_34(weight1_34),
		.weight1_41(weight1_41),
		.weight1_42(weight1_42),
		.weight1_43(weight1_43),
		.weight1_44(weight1_44),
		
		.weight2_11(weight2_11),
		.weight2_12(weight2_12),
		.weight2_13(weight2_13),
		.weight2_14(weight2_14),
		.weight2_21(weight2_21),
		.weight2_22(weight2_22),
		.weight2_23(weight2_23),
		.weight2_24(weight2_24),
		.weight2_31(weight2_31),
		.weight2_32(weight2_32),
		.weight2_33(weight2_33),
		.weight2_34(weight2_34),
		.weight2_41(weight2_41),
		.weight2_42(weight2_42),
		.weight2_43(weight2_43),
		.weight2_44(weight2_44)
		);
		
	//internal wire for index_aux LUT
	wire [7:0]	index_aux_out1, index_aux_out2, index_aux_out3, index_aux_out4;
	index_aux_LUT index_aux_LUT_u(
		.clk(clk1),
		.angle_or_planar(angle_or_planar),
		.address(address1),
		
		.LUT_out1(index_aux_out1),
		.LUT_out2(index_aux_out2),
		.LUT_out3(index_aux_out3),
		.LUT_out4(index_aux_out4)
		);
		
	//ref address
	wire top_or_left11,top_or_left12,top_or_left13,top_or_left14,
		  top_or_left21,top_or_left22,top_or_left23,top_or_left24,
		  top_or_left31,top_or_left32,top_or_left33,top_or_left34,
		  top_or_left41,top_or_left42,top_or_left43,top_or_left44;
	wire [7:0] address11, address14, address41, address44;
	wire [7:0] address11_r, address12_r, address13_r, address14_r,
              address21_r, address22_r, address23_r, address24_r, 
				  address31_r, address32_r, address33_r, address34_r, 
				  address41_r, address42_r, address43_r, address44_r;
	ref_address ref_address_u(
		.vh_i(vh_i),
		
		.index1(index_LUT_out1),
		.index2(index_LUT_out2),
		.index3(index_LUT_out3),
		.index4(index_LUT_out4),
		.index_aux1(index_aux_out1),
		.index_aux2(index_aux_out2),
		.index_aux3(index_aux_out3),
		.index_aux4(index_aux_out4),
		
		.X({2'd0,X}),
		.Y({2'd0,Y}),
		
		.top_or_left11(top_or_left11),
		.top_or_left12(top_or_left12),
		.top_or_left13(top_or_left13),
		.top_or_left14(top_or_left14),
		.top_or_left21(top_or_left21),
		.top_or_left22(top_or_left22),
		.top_or_left23(top_or_left23),
		.top_or_left24(top_or_left24),
		.top_or_left31(top_or_left31),
		.top_or_left32(top_or_left32),
		.top_or_left33(top_or_left33),
		.top_or_left34(top_or_left34),
		.top_or_left41(top_or_left41),
		.top_or_left42(top_or_left42),
		.top_or_left43(top_or_left43),
		.top_or_left44(top_or_left44),
		.address11(address11),
		.address12(),
		.address13(),
		.address14(address14),
		.address21(),
		.address22(),
		.address23(),
		.address24(),
		.address31(),
		.address32(),
		.address33(),
		.address34(),
		.address41(address41),
		.address42(),
		.address43(),
		.address44(address44),
		
		.address11_R(address11_r),
		.address12_R(address12_r),
		.address13_R(address13_r),
		.address14_R(address14_r),
		.address21_R(address21_r),
		.address22_R(address22_r),
		.address23_R(address23_r),
		.address24_R(address24_r),
		.address31_R(address31_r),
		.address32_R(address32_r),
		.address33_R(address33_r),
		.address34_R(address34_r),
		.address41_R(address41_r),
		.address42_R(address42_r),
		.address43_R(address43_r),
		.address44_R(address44_r),
		.negetive_flag(negetive_flag)
		);
		
/*
	下面的程序是在选择角度预测的相对地址和PLANAR预测的相对地址中选择
*/
	wire top_or_left1_11,top_or_left1_12,top_or_left1_13,top_or_left1_14,
		  top_or_left1_21,top_or_left1_22,top_or_left1_23,top_or_left1_24,
		  top_or_left1_31,top_or_left1_32,top_or_left1_33,top_or_left1_34,
		  top_or_left1_41,top_or_left1_42,top_or_left1_43,top_or_left1_44,
		  top_or_left2_11,top_or_left2_12,top_or_left2_13,top_or_left2_14,
		  top_or_left2_21,top_or_left2_22,top_or_left2_23,top_or_left2_24,
		  top_or_left2_31,top_or_left2_32,top_or_left2_33,top_or_left2_34,
		  top_or_left2_41,top_or_left2_42,top_or_left2_43,top_or_left2_44;
	wire [7:0] address1_11,address1_12,address1_13,address1_14,
				  address1_21,address1_22,address1_23,address1_24,
				  address1_31,address1_32,address1_33,address1_34,
				  address1_41,address1_42,address1_43,address1_44,
				  address2_11,address2_12,address2_13,address2_14,
				  address2_21,address2_22,address2_23,address2_24,
				  address2_31,address2_32,address2_33,address2_34,
				  address2_41,address2_42,address2_43,address2_44;
	address_abitrate_R address_abitrate_R_u(
		.angle_or_planar(angle_or_planar),
		
		.top_or_left11(top_or_left11),
		.top_or_left12(top_or_left12),
		.top_or_left13(top_or_left13),
		.top_or_left14(top_or_left14),
		.top_or_left21(top_or_left21),
		.top_or_left22(top_or_left22),
		.top_or_left23(top_or_left23),
		.top_or_left24(top_or_left24),
		.top_or_left31(top_or_left31),
		.top_or_left32(top_or_left32),
		.top_or_left33(top_or_left33),
		.top_or_left34(top_or_left34),
		.top_or_left41(top_or_left41),
		.top_or_left42(top_or_left42),
		.top_or_left43(top_or_left43),
		.top_or_left44(top_or_left44),
		
		.address_angle11(address11_r),
		.address_angle12(address12_r),
		.address_angle13(address13_r),
		.address_angle14(address14_r),
		.address_angle21(address21_r),
		.address_angle22(address22_r),
		.address_angle23(address23_r),
		.address_angle24(address24_r),
		.address_angle31(address31_r),
		.address_angle32(address32_r),
		.address_angle33(address33_r),
		.address_angle34(address34_r),
		.address_angle41(address41_r),
		.address_angle42(address42_r),
		.address_angle43(address43_r),
		.address_angle44(address44_r),
		
		.top_or_left1_11(top_or_left1_11),
		.top_or_left1_12(top_or_left1_12),
		.top_or_left1_13(top_or_left1_13),
		.top_or_left1_14(top_or_left1_14),
		.top_or_left1_21(top_or_left1_21),
		.top_or_left1_22(top_or_left1_22),
		.top_or_left1_23(top_or_left1_23),
		.top_or_left1_24(top_or_left1_24),
		.top_or_left1_31(top_or_left1_31),
		.top_or_left1_32(top_or_left1_32),
		.top_or_left1_33(top_or_left1_33),
		.top_or_left1_34(top_or_left1_34),
		.top_or_left1_41(top_or_left1_41),
		.top_or_left1_42(top_or_left1_42),
		.top_or_left1_43(top_or_left1_43),
		.top_or_left1_44(top_or_left1_44),
		
		.top_or_left2_11(top_or_left2_11),
		.top_or_left2_12(top_or_left2_12),
		.top_or_left2_13(top_or_left2_13),
		.top_or_left2_14(top_or_left2_14),
		.top_or_left2_21(top_or_left2_21),
		.top_or_left2_22(top_or_left2_22),
		.top_or_left2_23(top_or_left2_23),
		.top_or_left2_24(top_or_left2_24),
		.top_or_left2_31(top_or_left2_31),
		.top_or_left2_32(top_or_left2_32),
		.top_or_left2_33(top_or_left2_33),
		.top_or_left2_34(top_or_left2_34),
		.top_or_left2_41(top_or_left2_41),
		.top_or_left2_42(top_or_left2_42),
		.top_or_left2_43(top_or_left2_43),
		.top_or_left2_44(top_or_left2_44),
		
		.address1_11(address1_11),
		.address1_12(address1_12),
		.address1_13(address1_13),
		.address1_14(address1_14),
		.address1_21(address1_21),
		.address1_22(address1_22),
		.address1_23(address1_23),
		.address1_24(address1_24),
		.address1_31(address1_31),
		.address1_32(address1_32),
		.address1_33(address1_33),
		.address1_34(address1_34),
		.address1_41(address1_41),
		.address1_42(address1_42),
		.address1_43(address1_43),
		.address1_44(address1_44),
		
		.address2_11(address2_11),
		.address2_12(address2_12),
		.address2_13(address2_13),
		.address2_14(address2_14),
		.address2_21(address2_21),
		.address2_22(address2_22),
		.address2_23(address2_23),
		.address2_24(address2_24),
		.address2_31(address2_31),
		.address2_32(address2_32),
		.address2_33(address2_33),
		.address2_34(address2_34),
		.address2_41(address2_41),
		.address2_42(address2_42),
		.address2_43(address2_43),
		.address2_44(address2_44)
		);
		
		
/*
	以下模块主要是产生递增的读取参考像素的地址，
	随着时钟clk触发，就递增读取参考像素RAM的地址
*/
	wire en_top_angle,en_left_angle;
	wire [7:0]	address_RAM_angle;
	address_abitrate address_abitrate_u(
		.clk(clk),
		.rst_n(rst_n),
		.vh_i(vh_i),
		.preset_flag(clk1),
		.negetive_flag(negetive_flag),
		.negetive_pred(negetive_pred),
			
		.top_or_left11(top_or_left11),
		.top_or_left14(top_or_left14),
		.top_or_left41(top_or_left41),
		.top_or_left44(top_or_left44),
		.address11(address11),
		.address14(address14),
		.address41(address41),
		.address44(address44),
			
		.address_RAM(address_RAM_angle),
		.en_top(en_top_angle),
		.en_left(en_left_angle)
		);
		
/*
	以下模块主要是产生Planar预测的递增参考像素地址
*/
	wire en_top_planar,en_left_planar;
	wire [7:0]address_RAM_planar;
	address_abitrate_planar address_abitrate_planar_u(
		.CLK(clk),
		.RST_n(rst_n),
		.PU(PU),
		.preset_flag(clk1),
		
		.X(X),
		.Y(Y),
		.TOP_RIGHT(top_right),
		.BOTTOM_LEFT(bottom_left),
		
		.ADDRESS_RAM(address_RAM_planar),
		.EN_TOP(en_top_planar),
		.EN_LEFT(en_left_planar)
		);
/*
	以下模块主要是产生DC预测的递增参考像素地址
*/
	wire en_top_DC,en_left_DC;
	wire [7:0] address_RAM_DC;
	ADDRESS_ABITRATE_DC ADDRESS_ABITRATE_DC_u(
		.CLK_HIGH(clk),
		.RST_n(rst_n),
		.preset_flag(clk1),
		
		.X(X),
		.Y(Y),
		
		.ADDR(address_RAM_DC),
		.EN_TOP(en_top_DC),
		.EN_LEFT(en_left_DC)
		);

	wire [7:0]	address_RAM;
	//wire en_top,en_left;
	address_to_RAM address_to_RAM_u(
		.address_RAM_angle(address_RAM_angle),
		.address_RAM_planar(address_RAM_planar),
		.address_RAM_DC(address_RAM_DC),
		
		.en_top_angle(en_top_angle),
		.en_left_angle(en_left_angle),
		.en_top_planar(en_top_planar),
		.en_left_planar(en_left_planar),
		.en_top_DC(en_top_DC),
		.en_left_DC(en_left_DC),
		
		.angle_or_planar(angle_or_planar),
		.DC_flag(DC_flag),
		
		.address_RAM(address_RAM),
		.en_top(en_top),
		.en_left(en_left)
		);
	
/*
	以下模块主要是对参考像素RAM的读取以及对读取后的数据进行缓存
*/	
	wire [7:0]	ref_top_data, ref_left_data;
	wire [7:0]	ref_top0,ref_top1,ref_top2,ref_top3,ref_top4,ref_top5,ref_top6,ref_top7;
	wire [7:0]	ref_left0,ref_left1,ref_left2,ref_left3,ref_left4,ref_left5,ref_left6,ref_left7;
	REF_TOP REF_TOP_u(
		.clock(clk),
		.address(address_RAM),
		.data(),
		.wren(1'b0),
		.q(ref_top_data)
		);
		
	REF_LEFT REF_LEFT_u(
		.clock(clk),
		.address(address_RAM),
		.data(),
		.wren(1'b0),
		.q(ref_left_data)
		);
		
	TOP_REF_BUFFER TOP_REF_BUFFER_u(
		.CLK(clk),
		.RST_n(rst_n),
		.EN_TOP(en_top),
		.preset(clk1),
		.REF_DATA(ref_top_data),
		
		.REF_TOP0(ref_top0),
		.REF_TOP1(ref_top1),
		.REF_TOP2(ref_top2),
		.REF_TOP3(ref_top3),
		.REF_TOP4(ref_top4),
		.REF_TOP5(ref_top5),
		.REF_TOP6(ref_top6),
		.REF_TOP7(ref_top7)
		);
		
	LEFT_REF_BUFFER LEFT_REF_BUFFER_u(
		.CLK(clk),
		.RST_n(rst_n),
		.EN_LEFT(en_left),
		.preset(clk1),
		.REF_DATA(ref_left_data),
		
		.REF_LEFT0(ref_left0),
		.REF_LEFT1(ref_left1),
		.REF_LEFT2(ref_left2),
		.REF_LEFT3(ref_left3),
		.REF_LEFT4(ref_left4),
		.REF_LEFT5(ref_left5),
		.REF_LEFT6(ref_left6),
		.REF_LEFT7(ref_left7)
		);
		
/*
	下面的模块是对参考像素进行平滑滤波，包含角度预测的平滑滤波和PLANAR预测的滤波
*/
	wire [7:0]ref_top_f0_angle,ref_top_f1_angle,ref_top_f2_angle,ref_top_f3_angle,
				 ref_top_f4_angle,ref_top_f5_angle,ref_top_f6_angle,ref_top_f7_angle;
	wire [7:0]ref_left_f0_angle,ref_left_f1_angle,ref_left_f2_angle,ref_left_f3_angle,
				 ref_left_f4_angle,ref_left_f5_angle,ref_left_f6_angle,ref_left_f7_angle;
	
	REF_FILTER REF_FILTER_u(
		.CLK1(clk1),
		.filter_flag(1'b1),
		.REF_TOP0(ref_top0),
		.REF_TOP1(ref_top1),
		.REF_TOP2(ref_top2),
		.REF_TOP3(ref_top3),
		.REF_TOP4(ref_top4),
		.REF_TOP5(ref_top5),
		.REF_TOP6(ref_top6),
		.REF_TOP7(ref_top7),
		.REF_LEFT0(ref_left0),
		.REF_LEFT1(ref_left1),
		.REF_LEFT2(ref_left2),
		.REF_LEFT3(ref_left3),
		.REF_LEFT4(ref_left4),
		.REF_LEFT5(ref_left5),
		.REF_LEFT6(ref_left6),
		.REF_LEFT7(ref_left7),
		
		.REF_TOP_F0(ref_top_f0_angle),
		.REF_TOP_F1(ref_top_f1_angle),
		.REF_TOP_F2(ref_top_f2_angle),
		.REF_TOP_F3(ref_top_f3_angle),
		.REF_TOP_F4(ref_top_f4_angle),
		.REF_TOP_F5(ref_top_f5_angle),
		.REF_TOP_F6(ref_top_f6_angle),
		.REF_TOP_F7(ref_top_f7_angle),
		.REF_LEFT_F0(ref_left_f0_angle),
		.REF_LEFT_F1(ref_left_f1_angle),
		.REF_LEFT_F2(ref_left_f2_angle),
		.REF_LEFT_F3(ref_left_f3_angle),
		.REF_LEFT_F4(ref_left_f4_angle),
		.REF_LEFT_F5(ref_left_f5_angle),
		.REF_LEFT_F6(ref_left_f6_angle),
		.REF_LEFT_F7(ref_left_f7_angle)
		);
	
	wire [7:0]ref_top_f0_planar,ref_top_f1_planar,ref_top_f2_planar,ref_top_f3_planar,
				 ref_top_f4_planar,ref_top_f5_planar,ref_top_f6_planar,ref_top_f7_planar;
	wire [7:0]ref_left_f0_planar,ref_left_f1_planar,ref_left_f2_planar,ref_left_f3_planar,
				 ref_left_f4_planar,ref_left_f5_planar,ref_left_f6_planar,ref_left_f7_planar;
	REF_FILTER_planar REF_FILTER_planar_u(
		.CLK1(clk1),
		
		.REF_TOP0(ref_top0),
		.REF_TOP1(ref_top1),
		.REF_TOP2(ref_top2),
		.REF_TOP3(ref_top3),
		.REF_TOP4(ref_top4),
		.REF_TOP5(ref_top5),
		.REF_TOP6(ref_top6),
		.REF_TOP7(ref_top7),
		
		.REF_LEFT0(ref_left0),
		.REF_LEFT1(ref_left1),
		.REF_LEFT2(ref_left2),
		.REF_LEFT3(ref_left3),
		.REF_LEFT4(ref_left4),
		.REF_LEFT5(ref_left5),
		.REF_LEFT6(ref_left6),
		.REF_LEFT7(ref_left7),
		
		.REF_TOP_F0(ref_top_f0_planar),
		.REF_TOP_F1(ref_top_f1_planar),
		.REF_TOP_F2(ref_top_f2_planar),
		.REF_TOP_F3(ref_top_f3_planar),
		.REF_TOP_F4(ref_top_f4_planar),
		.REF_TOP_F5(ref_top_f5_planar),
		.REF_TOP_F6(ref_top_f6_planar),
		.REF_TOP_F7(ref_top_f7_planar),
		
		.REF_LEFT_F0(ref_left_f0_planar),
		.REF_LEFT_F1(ref_left_f1_planar),
		.REF_LEFT_F2(ref_left_f2_planar),
		.REF_LEFT_F3(ref_left_f3_planar),
		.REF_LEFT_F4(ref_left_f4_planar),
		.REF_LEFT_F5(ref_left_f5_planar),
		.REF_LEFT_F6(ref_left_f6_planar),
		.REF_LEFT_F7(ref_left_f7_planar)
		);
	
	wire [7:0]ref_top_f0,ref_top_f1,ref_top_f2,ref_top_f3,
				 ref_top_f4,ref_top_f5,ref_top_f6,ref_top_f7;
	wire [7:0]ref_left_f0,ref_left_f1,ref_left_f2,ref_left_f3,
				 ref_left_f4,ref_left_f5,ref_left_f6,ref_left_f7;
	REF_ABITRATE REF_ABITRATE_u(
		.angle_or_planar(angle_or_planar),
		
		.REF_TOP0_angle(ref_top_f0_angle),
		.REF_TOP1_angle(ref_top_f1_angle),
		.REF_TOP2_angle(ref_top_f2_angle),
		.REF_TOP3_angle(ref_top_f3_angle),
		.REF_TOP4_angle(ref_top_f4_angle),
		.REF_TOP5_angle(ref_top_f5_angle),
		.REF_TOP6_angle(ref_top_f6_angle),
		.REF_TOP7_angle(ref_top_f7_angle),
		
		.REF_LEFT0_angle(ref_left_f0_angle),
		.REF_LEFT1_angle(ref_left_f1_angle),
		.REF_LEFT2_angle(ref_left_f2_angle),
		.REF_LEFT3_angle(ref_left_f3_angle),
		.REF_LEFT4_angle(ref_left_f4_angle),
		.REF_LEFT5_angle(ref_left_f5_angle),
		.REF_LEFT6_angle(ref_left_f6_angle),
		.REF_LEFT7_angle(ref_left_f7_angle),
		
		.REF_TOP0_planar(ref_top_f0_planar),
		.REF_TOP1_planar(ref_top_f1_planar),
		.REF_TOP2_planar(ref_top_f2_planar),
		.REF_TOP3_planar(ref_top_f3_planar),
		.REF_TOP4_planar(ref_top_f4_planar),
		.REF_TOP5_planar(ref_top_f5_planar),
		.REF_TOP6_planar(ref_top_f6_planar),
		.REF_TOP7_planar(ref_top_f7_planar),
		
		.REF_LEFT0_planar(ref_left_f0_planar),
		.REF_LEFT1_planar(ref_left_f1_planar),
		.REF_LEFT2_planar(ref_left_f2_planar),
		.REF_LEFT3_planar(ref_left_f3_planar),
		.REF_LEFT4_planar(ref_left_f4_planar),
		.REF_LEFT5_planar(ref_left_f5_planar),
		.REF_LEFT6_planar(ref_left_f6_planar),
		.REF_LEFT7_planar(ref_left_f7_planar),
		
		.REF_TOP0(ref_top_f0),
		.REF_TOP1(ref_top_f1),
		.REF_TOP2(ref_top_f2),
		.REF_TOP3(ref_top_f3),
		.REF_TOP4(ref_top_f4),
		.REF_TOP5(ref_top_f5),
		.REF_TOP6(ref_top_f6),
		.REF_TOP7(ref_top_f7),
		
		.REF_LEFT0(ref_left_f0),
		.REF_LEFT1(ref_left_f1),
		.REF_LEFT2(ref_left_f2),
		.REF_LEFT3(ref_left_f3),
		.REF_LEFT4(ref_left_f4),
		.REF_LEFT5(ref_left_f5),
		.REF_LEFT6(ref_left_f6),
		.REF_LEFT7(ref_left_f7)
		);
		
	
/*
	以下是预测计算模块
*/
	wire [7:0]	pred_out11_ap,pred_out12_ap,pred_out13_ap,pred_out14_ap,
					pred_out21_ap,pred_out22_ap,pred_out23_ap,pred_out24_ap,
					pred_out31_ap,pred_out32_ap,pred_out33_ap,pred_out34_ap,
					pred_out41_ap,pred_out42_ap,pred_out43_ap,pred_out44_ap;
	PRED_16PIX PRED_16PIX_u(
		.PU(PU),
		.complete_flag_angle(complete_flag_angle),
		.complete_flag_planar(complete_flag_planar),
		.angle_or_planar(angle_or_planar),
		.TOP_or_LEFT1_11(top_or_left1_11),
		.TOP_or_LEFT1_12(top_or_left1_12),
		.TOP_or_LEFT1_13(top_or_left1_13),
		.TOP_or_LEFT1_14(top_or_left1_14),
		.TOP_or_LEFT1_21(top_or_left1_21),
		.TOP_or_LEFT1_22(top_or_left1_22),
		.TOP_or_LEFT1_23(top_or_left1_23),
		.TOP_or_LEFT1_24(top_or_left1_24),
		.TOP_or_LEFT1_31(top_or_left1_31),
		.TOP_or_LEFT1_32(top_or_left1_32),
		.TOP_or_LEFT1_33(top_or_left1_33),
		.TOP_or_LEFT1_34(top_or_left1_34),
		.TOP_or_LEFT1_41(top_or_left1_41),
		.TOP_or_LEFT1_42(top_or_left1_42),
		.TOP_or_LEFT1_43(top_or_left1_43),
		.TOP_or_LEFT1_44(top_or_left1_44),
		
		.TOP_or_LEFT2_11(top_or_left2_11),
		.TOP_or_LEFT2_12(top_or_left2_12),
		.TOP_or_LEFT2_13(top_or_left2_13),
		.TOP_or_LEFT2_14(top_or_left2_14),
		.TOP_or_LEFT2_21(top_or_left2_21),
		.TOP_or_LEFT2_22(top_or_left2_22),
		.TOP_or_LEFT2_23(top_or_left2_23),
		.TOP_or_LEFT2_24(top_or_left2_24),
		.TOP_or_LEFT2_31(top_or_left2_31),
		.TOP_or_LEFT2_32(top_or_left2_32),
		.TOP_or_LEFT2_33(top_or_left2_33),
		.TOP_or_LEFT2_34(top_or_left2_34),
		.TOP_or_LEFT2_41(top_or_left2_41),
		.TOP_or_LEFT2_42(top_or_left2_42),
		.TOP_or_LEFT2_43(top_or_left2_43),
		.TOP_or_LEFT2_44(top_or_left2_44),
		
		.REF_TOP0(ref_top_f0),
		.REF_TOP1(ref_top_f1),
		.REF_TOP2(ref_top_f2),
		.REF_TOP3(ref_top_f3),
		.REF_TOP4(ref_top_f4),
		.REF_TOP5(ref_top_f5),
		.REF_TOP6(ref_top_f6),
		.REF_TOP7(ref_top_f7),
		
		.REF_TOP0a(ref_top0),
		.REF_TOP1a(ref_top1),
		.REF_TOP2a(ref_top2),
		.REF_TOP3a(ref_top3),
		.REF_TOP4a(ref_top4),
		.REF_TOP5a(ref_top5),
		.REF_TOP6a(ref_top6),
		.REF_TOP7a(ref_top7),
		
		.REF_LEFT0(ref_left_f0),
		.REF_LEFT1(ref_left_f1),
		.REF_LEFT2(ref_left_f2),
		.REF_LEFT3(ref_left_f3),
		.REF_LEFT4(ref_left_f4),
		.REF_LEFT5(ref_left_f5),
		.REF_LEFT6(ref_left_f6),
		.REF_LEFT7(ref_left_f7),
		
		.REF_LEFT0a(ref_left0),
		.REF_LEFT1a(ref_left1),
		.REF_LEFT2a(ref_left2),
		.REF_LEFT3a(ref_left3),
		.REF_LEFT4a(ref_left4),
		.REF_LEFT5a(ref_left5),
		.REF_LEFT6a(ref_left6),
		.REF_LEFT7a(ref_left7),
		
		.ADDR1_11(address1_11),
		.ADDR1_12(address1_12),
		.ADDR1_13(address1_13),
		.ADDR1_14(address1_14),
		.ADDR1_21(address1_21),
		.ADDR1_22(address1_22),
		.ADDR1_23(address1_23),
		.ADDR1_24(address1_24),
		.ADDR1_31(address1_31),
		.ADDR1_32(address1_32),
		.ADDR1_33(address1_33),
		.ADDR1_34(address1_34),
		.ADDR1_41(address1_41),
		.ADDR1_42(address1_42),
		.ADDR1_43(address1_43),
		.ADDR1_44(address1_44),
		
		.ADDR2_11(address2_11),
		.ADDR2_12(address2_12),
		.ADDR2_13(address2_13),
		.ADDR2_14(address2_14),
		.ADDR2_21(address2_21),
		.ADDR2_22(address2_22),
		.ADDR2_23(address2_23),
		.ADDR2_24(address2_24),
		.ADDR2_31(address2_31),
		.ADDR2_32(address2_32),
		.ADDR2_33(address2_33),
		.ADDR2_34(address2_34),
		.ADDR2_41(address2_41),
		.ADDR2_42(address2_42),
		.ADDR2_43(address2_43),
		.ADDR2_44(address2_44),
		
		.WEIGHT1_11(weight1_11),
		.WEIGHT1_12(weight1_12),
		.WEIGHT1_13(weight1_13),
		.WEIGHT1_14(weight1_14),
		.WEIGHT1_21(weight1_21),
		.WEIGHT1_22(weight1_22),
		.WEIGHT1_23(weight1_23),
		.WEIGHT1_24(weight1_24),
		.WEIGHT1_31(weight1_31),
		.WEIGHT1_32(weight1_32),
		.WEIGHT1_33(weight1_33),
		.WEIGHT1_34(weight1_34),
		.WEIGHT1_41(weight1_41),
		.WEIGHT1_42(weight1_42),
		.WEIGHT1_43(weight1_43),
		.WEIGHT1_44(weight1_44),
		
		.WEIGHT2_11(weight2_11),
		.WEIGHT2_12(weight2_12),
		.WEIGHT2_13(weight2_13),
		.WEIGHT2_14(weight2_14),
		.WEIGHT2_21(weight2_21),
		.WEIGHT2_22(weight2_22),
		.WEIGHT2_23(weight2_23),
		.WEIGHT2_24(weight2_24),
		.WEIGHT2_31(weight2_31),
		.WEIGHT2_32(weight2_32),
		.WEIGHT2_33(weight2_33),
		.WEIGHT2_34(weight2_34),
		.WEIGHT2_41(weight2_41),
		.WEIGHT2_42(weight2_42),
		.WEIGHT2_43(weight2_43),
		.WEIGHT2_44(weight2_44),
		
		.complete_flag(complete_flag),
		.PRED_OUT11(pred_out11_ap),
		.PRED_OUT12(pred_out12_ap),
		.PRED_OUT13(pred_out13_ap),
		.PRED_OUT14(pred_out14_ap),
		.PRED_OUT21(pred_out21_ap),
		.PRED_OUT22(pred_out22_ap),
		.PRED_OUT23(pred_out23_ap),
		.PRED_OUT24(pred_out24_ap),
		.PRED_OUT31(pred_out31_ap),
		.PRED_OUT32(pred_out32_ap),
		.PRED_OUT33(pred_out33_ap),
		.PRED_OUT34(pred_out34_ap),
		.PRED_OUT41(pred_out41_ap),
		.PRED_OUT42(pred_out42_ap),
		.PRED_OUT43(pred_out43_ap),
		.PRED_OUT44(pred_out44_ap)
		);
	
	wire [7:0] pred_out11_DC,pred_out12_DC,pred_out13_DC,pred_out14_DC,
				  pred_out21_DC,pred_out22_DC,pred_out23_DC,pred_out24_DC,
				  pred_out31_DC,pred_out32_DC,pred_out33_DC,pred_out34_DC,
				  pred_out41_DC,pred_out42_DC,pred_out43_DC,pred_out44_DC;
	DC_PRED_UNIT DC_PRED_UNIT_u(
		.PU(PU),
		.LEFT_VALID(left_valid),
		.TOP_VALID(top_valid),
		.DCVAL_flag(dcval_flag),
		
		.TOP_REF0(ref_top0),
		.TOP_REF1(ref_top1),
		.TOP_REF2(ref_top2),
		.TOP_REF3(ref_top3),
		
		.LEFT_REF0(ref_left0),
		.LEFT_REF1(ref_left1),
		.LEFT_REF2(ref_left2),
		.LEFT_REF3(ref_left3),
		
		.PRED_OUT11(pred_out11_DC),
		.PRED_OUT12(pred_out12_DC),
		.PRED_OUT13(pred_out13_DC),
		.PRED_OUT14(pred_out14_DC),
		.PRED_OUT21(pred_out21_DC),
		.PRED_OUT22(pred_out22_DC),
		.PRED_OUT23(pred_out23_DC),
		.PRED_OUT24(pred_out24_DC),
		.PRED_OUT31(pred_out31_DC),
		.PRED_OUT32(pred_out32_DC),
		.PRED_OUT33(pred_out33_DC),
		.PRED_OUT34(pred_out34_DC),
		.PRED_OUT41(pred_out41_DC),
		.PRED_OUT42(pred_out42_DC),
		.PRED_OUT43(pred_out43_DC),
		.PRED_OUT44(pred_out44_DC)
		);
	
	wire [7:0] pred_out11,pred_out12,pred_out13,pred_out14,
				  pred_out21,pred_out22,pred_out23,pred_out24,
				  pred_out31,pred_out32,pred_out33,pred_out34,
				  pred_out41,pred_out42,pred_out43,pred_out44;
	DC_OR_AP_OUT DC_OR_AP_OUT_u(
		.CLK_LOW(clk1),
		.DC_flag(DC_flag),
		
		.PRED11_AP(pred_out11_ap),
		.PRED12_AP(pred_out12_ap),
		.PRED13_AP(pred_out13_ap),
		.PRED14_AP(pred_out14_ap),
		.PRED21_AP(pred_out21_ap),
		.PRED22_AP(pred_out22_ap),
		.PRED23_AP(pred_out23_ap),
		.PRED24_AP(pred_out24_ap),
		.PRED31_AP(pred_out31_ap),
		.PRED32_AP(pred_out32_ap),
		.PRED33_AP(pred_out33_ap),
		.PRED34_AP(pred_out34_ap),
		.PRED41_AP(pred_out41_ap),
		.PRED42_AP(pred_out42_ap),
		.PRED43_AP(pred_out43_ap),
		.PRED44_AP(pred_out44_ap),
		
		.PRED11_DC(pred_out11_DC),
		.PRED12_DC(pred_out12_DC),
		.PRED13_DC(pred_out13_DC),
		.PRED14_DC(pred_out14_DC),
		.PRED21_DC(pred_out21_DC),
		.PRED22_DC(pred_out22_DC),
		.PRED23_DC(pred_out23_DC),
		.PRED24_DC(pred_out24_DC),
		.PRED31_DC(pred_out31_DC),
		.PRED32_DC(pred_out32_DC),
		.PRED33_DC(pred_out33_DC),
		.PRED34_DC(pred_out34_DC),
		.PRED41_DC(pred_out41_DC),
		.PRED42_DC(pred_out42_DC),
		.PRED43_DC(pred_out43_DC),
		.PRED44_DC(pred_out44_DC),
		
		.PRED_OUT11(pred_out11),
		.PRED_OUT12(pred_out12),
		.PRED_OUT13(pred_out13),
		.PRED_OUT14(pred_out14),
		.PRED_OUT21(pred_out21),
		.PRED_OUT22(pred_out22),
		.PRED_OUT23(pred_out23),
		.PRED_OUT24(pred_out24),
		.PRED_OUT31(pred_out31),
		.PRED_OUT32(pred_out32),
		.PRED_OUT33(pred_out33),
		.PRED_OUT34(pred_out34),
		.PRED_OUT41(pred_out41),
		.PRED_OUT42(pred_out42),
		.PRED_OUT43(pred_out43),
		.PRED_OUT44(pred_out44)
		);
	
	reg ena1,ena2;
	reg complete1,complete2,complete_vga;
	always @(posedge clk1) ena1 <= read_ena;
	always @(posedge clk1) ena2 <= ena1;
	
	always @(posedge clk1) complete1 <= complete_flag;
	always @(posedge clk1) complete2 <= complete1;
	
	always @(posedge complete2)
	begin
		complete_vga <= 1'b1;
	end
	
	reg [5:0] x_ram1,x_ram2,y_ram1,y_ram2;
	always @(posedge clk1) x_ram1 <= X;
	always @(posedge clk1) x_ram2 <= x_ram1;
	always @(posedge clk1) y_ram1 <= Y;
	always @(posedge clk1) y_ram2 <= y_ram1;
	
	wire [12:0]address_write_ram11,address_write_ram12,address_write_ram13,address_write_ram14,
				  address_write_ram21,address_write_ram22,address_write_ram23,address_write_ram24,
				  address_write_ram31,address_write_ram32,address_write_ram33,address_write_ram34,
				  address_write_ram41,address_write_ram42,address_write_ram43,address_write_ram44;
	assign address_write_ram11 = y_ram2*7'd64+{7'd0,x_ram2};
	assign address_write_ram12 = y_ram2*7'd64+{7'd0,x_ram2}+13'd1;
	assign address_write_ram13 = y_ram2*7'd64+{7'd0,x_ram2}+13'd2;
	assign address_write_ram14 = y_ram2*7'd64+{7'd0,x_ram2}+13'd3;
	assign address_write_ram21 = y_ram2*7'd64+13'd64+{7'd0,x_ram2};
	assign address_write_ram22 = y_ram2*7'd64+13'd64+{7'd0,x_ram2}+13'd1;
	assign address_write_ram23 = y_ram2*7'd64+13'd64+{7'd0,x_ram2}+13'd2;
	assign address_write_ram24 = y_ram2*7'd64+13'd64+{7'd0,x_ram2}+13'd3;
	assign address_write_ram31 = y_ram2*7'd64+13'd128+{7'd0,x_ram2};
	assign address_write_ram32 = y_ram2*7'd64+13'd128+{7'd0,x_ram2}+13'd1;
	assign address_write_ram33 = y_ram2*7'd64+13'd128+{7'd0,x_ram2}+13'd2;
	assign address_write_ram34 = y_ram2*7'd64+13'd128+{7'd0,x_ram2}+13'd3;
	assign address_write_ram41 = y_ram2*7'd64+13'd192+{7'd0,x_ram2};
	assign address_write_ram42 = y_ram2*7'd64+13'd192+{7'd0,x_ram2}+13'd1;
	assign address_write_ram43 = y_ram2*7'd64+13'd192+{7'd0,x_ram2}+13'd2;
	assign address_write_ram44 = y_ram2*7'd64+13'd192+{7'd0,x_ram2}+13'd3;
	
	reg [3:0] ram_count;
	always @(posedge clk)
	begin
		if(clk1==1'b1)
		begin
			ram_count <= 4'd0;
		end
		else if(ena2==1'b1)
		begin
			ram_count <= ram_count + 4'd1;
		end
	end
	
	reg [7:0] ram_data;
	reg [12:0] ram_addr;
	wire [7:0] ram_data1;
	wire [12:0] ram_addr1;
	always @(clk)
	begin
		case(ram_count)
			4'd0:
			begin
				ram_data <= pred_out11;
				ram_addr <= address_write_ram11;
			end
			4'd1:
			begin
				ram_data <= pred_out12;
				ram_addr <= address_write_ram12;
			end
			4'd2:
			begin
				ram_data <= pred_out13;
				ram_addr <= address_write_ram13;
			end
			4'd3:
			begin
				ram_data <= pred_out14;
				ram_addr <= address_write_ram14;
			end
			4'd4:
			begin
				ram_data <= pred_out21;
				ram_addr <= address_write_ram21;
			end
			4'd5:
			begin
				ram_data <= pred_out22;
				ram_addr <= address_write_ram22;
			end
			4'd6:
			begin
				ram_data <= pred_out23;
				ram_addr <= address_write_ram23;
			end
			4'd7:
			begin
				ram_data <= pred_out24;
				ram_addr <= address_write_ram24;
			end
			4'd8:
			begin
				ram_data <= pred_out31;
				ram_addr <= address_write_ram31;
			end
			4'd9:
			begin
				ram_data <= pred_out32;
				ram_addr <= address_write_ram32;
			end
			4'd10:
			begin
				ram_data <= pred_out33;
				ram_addr <= address_write_ram33;
			end
			4'd11:
			begin
				ram_data <= pred_out34;
				ram_addr <= address_write_ram34;
			end
			4'd12:
			begin
				ram_data <= pred_out41;
				ram_addr <= address_write_ram41;
			end
			4'd13:
			begin
				ram_data <= pred_out42;
				ram_addr <= address_write_ram42;
			end
			4'd14:
			begin
				ram_data <= pred_out43;
				ram_addr <= address_write_ram43;
			end
			default:
			begin
				ram_data <= pred_out44;
				ram_addr <= address_write_ram44;
			end
		endcase
	end
	assign ram_data1 = ram_data;
	assign ram_addr1 = ram_addr;
	vga_controller v1(
		.iRST_n(rst_n),
		.iVGA_CLK(clk_vga),
		.clk(clk),
		.ena2(ena2),
		.DATA_w(ram_data1),
		.ADDR_w(ram_addr1[11:0]),
		.complete(complete_vga),
		.oBLANK_n(oBLANK_n),
		.oHS(oHS),
		.oVS(oVS),
		.b_data(b_data),
		.g_data(g_data),
		.r_data(r_data)
		);
	/*reg [12:0] count_ram;
	always @(posedge clk_LOW or negedge rst_n)
	begin
		if(rst_n==1'b0)
		begin
			count_ram <= 13'd0;
		end
		else if(ena2==1'b1)
		begin
			if(ena==13'd63)
				count_ram <= 13'd0;
			else
			count_ram <= count_ram + 5'd1;
		end
		else 
	end
	
	out11 out11_u(.address(count_ram),.clock(clk_LOW),.data(pred_out11),.wren(ena2),.rden(complete2),.q());
	out12 out12_u(.address(count_ram),.clock(clk_LOW),.data(pred_out12),.wren(ena2),.rden(complete2),.q());
	out13 out13_u(.address(count_ram),.clock(clk_LOW),.data(pred_out13),.wren(ena2),.rden(complete2),.q());
	out14 out14_u(.address(count_ram),.clock(clk_LOW),.data(pred_out14),.wren(ena2),.rden(complete2),.q());
	out21 out21_u(.address(count_ram),.clock(clk_LOW),.data(pred_out21),.wren(ena2),.rden(complete2),.q());
	out22 out22_u(.address(count_ram),.clock(clk_LOW),.data(pred_out22),.wren(ena2),.rden(complete2),.q());
	out23 out23_u(.address(count_ram),.clock(clk_LOW),.data(pred_out23),.wren(ena2),.rden(complete2),.q());
	out24 out24_u(.address(count_ram),.clock(clk_LOW),.data(pred_out24),.wren(ena2),.rden(complete2),.q());
	out31 out31_u(.address(count_ram),.clock(clk_LOW),.data(pred_out31),.wren(ena2),.rden(complete2),.q());
	out32 out32_u(.address(count_ram),.clock(clk_LOW),.data(pred_out32),.wren(ena2),.rden(complete2),.q());
	out33 out33_u(.address(count_ram),.clock(clk_LOW),.data(pred_out33),.wren(ena2),.rden(complete2),.q());
	out34 out34_u(.address(count_ram),.clock(clk_LOW),.data(pred_out34),.wren(ena2),.rden(complete2),.q());
	out41 out41_u(.address(count_ram),.clock(clk_LOW),.data(pred_out41),.wren(ena2),.rden(complete2),.q());
	out42 out42_u(.address(count_ram),.clock(clk_LOW),.data(pred_out42),.wren(ena2),.rden(complete2),.q());
	out43 out43_u(.address(count_ram),.clock(clk_LOW),.data(pred_out43),.wren(ena2),.rden(complete2),.q());
	out44 out44_u(.address(count_ram),.clock(clk_LOW),.data(pred_out44),.wren(ena2),.rden(complete2),.q());*/
	
endmodule
