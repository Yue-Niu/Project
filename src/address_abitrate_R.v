//这个模块是产生相对的地址来选择寄存器里的参考像素，
//由于把角度预测和Planar预测整合到一块了，所以这里
//对应不同的预测输出的相对地址也会不一样
module address_abitrate_R
(
	input angle_or_planar,
	
	input top_or_left11,
	input top_or_left12,
	input top_or_left13,
	input top_or_left14,
	input top_or_left21,
	input top_or_left22,
	input top_or_left23,
	input top_or_left24,
	input top_or_left31,
	input top_or_left32,
	input top_or_left33,
	input top_or_left34,
	input top_or_left41,
	input top_or_left42,
	input top_or_left43,
	input top_or_left44,
	
	input [7:0]	address_angle11,
	input [7:0]	address_angle12,
	input [7:0]	address_angle13,
	input [7:0]	address_angle14,
	input [7:0]	address_angle21,
	input [7:0]	address_angle22,
	input [7:0]	address_angle23,
	input [7:0]	address_angle24,
	input [7:0]	address_angle31,
	input [7:0]	address_angle32,
	input [7:0]	address_angle33,
	input [7:0]	address_angle34,
	input [7:0]	address_angle41,
	input [7:0]	address_angle42,
	input [7:0]	address_angle43,
	input [7:0]	address_angle44,
	
	output reg	top_or_left1_11,
	output reg  top_or_left1_12,
	output reg	top_or_left1_13,
	output reg	top_or_left1_14,
	output reg 	top_or_left1_21,
	output reg 	top_or_left1_22,
	output reg	top_or_left1_23,
	output reg	top_or_left1_24,
	output reg 	top_or_left1_31,
	output reg 	top_or_left1_32,
	output reg	top_or_left1_33,
	output reg	top_or_left1_34,
	output reg	top_or_left1_41,
	output reg	top_or_left1_42,
	output reg	top_or_left1_43,
	output reg	top_or_left1_44,
	
	output reg	top_or_left2_11,
	output reg	top_or_left2_12,
	output reg	top_or_left2_13,
	output reg	top_or_left2_14,
	output reg	top_or_left2_21,
	output reg	top_or_left2_22,
	output reg	top_or_left2_23,
	output reg	top_or_left2_24,
	output reg	top_or_left2_31,
	output reg	top_or_left2_32,
	output reg	top_or_left2_33,
	output reg	top_or_left2_34,
	output reg	top_or_left2_41,
	output reg	top_or_left2_42,
	output reg	top_or_left2_43,
	output reg	top_or_left2_44,
	
	output reg[7:0] address1_11,
	output reg[7:0] address1_12,
	output reg[7:0] address1_13,
	output reg[7:0] address1_14,
	output reg[7:0] address1_21,
	output reg[7:0] address1_22,
	output reg[7:0] address1_23,
	output reg[7:0] address1_24,
	output reg[7:0] address1_31,
	output reg[7:0] address1_32,
	output reg[7:0] address1_33,
	output reg[7:0] address1_34,
	output reg[7:0] address1_41,
	output reg[7:0] address1_42,
	output reg[7:0] address1_43,
	output reg[7:0] address1_44,
	
	output reg[7:0] address2_11,
	output reg[7:0] address2_12,
	output reg[7:0] address2_13,
	output reg[7:0] address2_14,
	output reg[7:0] address2_21,
	output reg[7:0] address2_22,
	output reg[7:0] address2_23,
	output reg[7:0] address2_24,
	output reg[7:0] address2_31,
	output reg[7:0] address2_32,
	output reg[7:0] address2_33,
	output reg[7:0] address2_34,
	output reg[7:0] address2_41,
	output reg[7:0] address2_42,
	output reg[7:0] address2_43,
	output reg[7:0] address2_44
);

	always @(angle_or_planar or
				top_or_left11 or top_or_left12 or top_or_left13 or top_or_left14 or 
				top_or_left21 or top_or_left22 or top_or_left23 or top_or_left24 or
				top_or_left31 or top_or_left32 or top_or_left33 or top_or_left34 or
				top_or_left41 or top_or_left42 or top_or_left43 or top_or_left44 or
				address_angle11 or address_angle12 or address_angle13 or address_angle14 or
				address_angle21 or address_angle22 or address_angle23 or address_angle24 or
				address_angle31 or address_angle32 or address_angle33 or address_angle34 or
				address_angle41 or address_angle42 or address_angle43 or address_angle44)
	begin
		if(angle_or_planar==1'b1)
		begin
			top_or_left1_11 <= top_or_left11;
			top_or_left1_12 <= top_or_left12;
			top_or_left1_13 <= top_or_left13;
			top_or_left1_14 <= top_or_left14;
			top_or_left1_21 <= top_or_left21;
			top_or_left1_22 <= top_or_left22;
			top_or_left1_23 <= top_or_left23;
			top_or_left1_24 <= top_or_left24;
			top_or_left1_31 <= top_or_left31;
			top_or_left1_32 <= top_or_left32;
			top_or_left1_33 <= top_or_left33;
			top_or_left1_34 <= top_or_left34;
			top_or_left1_41 <= top_or_left41;
			top_or_left1_42 <= top_or_left42;
			top_or_left1_43 <= top_or_left43;
			top_or_left1_44 <= top_or_left44;
			
			top_or_left2_11 <= top_or_left11;
			top_or_left2_12 <= top_or_left12;
			top_or_left2_13 <= top_or_left13;
			top_or_left2_14 <= top_or_left14;
			top_or_left2_21 <= top_or_left21;
			top_or_left2_22 <= top_or_left22;
			top_or_left2_23 <= top_or_left23;
			top_or_left2_24 <= top_or_left24;
			top_or_left2_31 <= top_or_left31;
			top_or_left2_32 <= top_or_left32;
			top_or_left2_33 <= top_or_left33;
			top_or_left2_34 <= top_or_left34;
			top_or_left2_41 <= top_or_left41;
			top_or_left2_42 <= top_or_left42;
			top_or_left2_43 <= top_or_left43;
			top_or_left2_44 <= top_or_left44;
		
			address1_11 <= address_angle11;
			address1_12 <= address_angle12;
			address1_13 <= address_angle13;
			address1_14 <= address_angle14;
			address1_21 <= address_angle21;
			address1_22 <= address_angle22;
			address1_23 <= address_angle23;
			address1_24 <= address_angle24;
			address1_31 <= address_angle31;
			address1_32 <= address_angle32;
			address1_33 <= address_angle33;
			address1_34 <= address_angle34;
			address1_41 <= address_angle41;
			address1_42 <= address_angle42;
			address1_43 <= address_angle43;
			address1_44 <= address_angle44;
			
			address2_11 <= address_angle11 + 8'd1;
			address2_12 <= address_angle12 + 8'd1;
			address2_13 <= address_angle13 + 8'd1;
			address2_14 <= address_angle14 + 8'd1;
			address2_21 <= address_angle21 + 8'd1;
			address2_22 <= address_angle22 + 8'd1;
			address2_23 <= address_angle23 + 8'd1;
			address2_24 <= address_angle24 + 8'd1;
			address2_31 <= address_angle31 + 8'd1;
			address2_32 <= address_angle32 + 8'd1;
			address2_33 <= address_angle33 + 8'd1;
			address2_34 <= address_angle34 + 8'd1;
			address2_41 <= address_angle41 + 8'd1;
			address2_42 <= address_angle42 + 8'd1;
			address2_43 <= address_angle43 + 8'd1;
			address2_44 <= address_angle44 + 8'd1;
		end
		else
		begin
			top_or_left1_11 <= 1'b1;
			top_or_left1_12 <= 1'b1;
			top_or_left1_13 <= 1'b1;
			top_or_left1_14 <= 1'b1;
			top_or_left1_21 <= 1'b1;
			top_or_left1_22 <= 1'b1;
			top_or_left1_23 <= 1'b1;
			top_or_left1_24 <= 1'b1;
			top_or_left1_31 <= 1'b1;
			top_or_left1_32 <= 1'b1;
			top_or_left1_33 <= 1'b1;
			top_or_left1_34 <= 1'b1;
			top_or_left1_41 <= 1'b1;
			top_or_left1_42 <= 1'b1;
			top_or_left1_43 <= 1'b1;
			top_or_left1_44 <= 1'b1;
			
			top_or_left2_11 <= 1'b0;
			top_or_left2_12 <= 1'b0;
			top_or_left2_13 <= 1'b0;
			top_or_left2_14 <= 1'b0;
			top_or_left2_21 <= 1'b0;
			top_or_left2_22 <= 1'b0;
			top_or_left2_23 <= 1'b0;
			top_or_left2_24 <= 1'b0;
			top_or_left2_31 <= 1'b0;
			top_or_left2_32 <= 1'b0;
			top_or_left2_33 <= 1'b0;
			top_or_left2_34 <= 1'b0;
			top_or_left2_41 <= 1'b0;
			top_or_left2_42 <= 1'b0;
			top_or_left2_43 <= 1'b0;
			top_or_left2_44 <= 1'b0;
		
			address1_11 <= 8'd0;
			address1_12 <= 8'd1;
			address1_13 <= 8'd2;
			address1_14 <= 8'd3;
			address1_21 <= 8'd0;
			address1_22 <= 8'd1;
			address1_23 <= 8'd2;
			address1_24 <= 8'd3;
			address1_31 <= 8'd0;
			address1_32 <= 8'd1;
			address1_33 <= 8'd2;
			address1_34 <= 8'd3;
			address1_41 <= 8'd0;
			address1_42 <= 8'd1;
			address1_43 <= 8'd2;
			address1_44 <= 8'd3;
			
			address2_11 <= 8'd0;
			address2_12 <= 8'd0;
			address2_13 <= 8'd0;
			address2_14 <= 8'd0;
			address2_21 <= 8'd1;
			address2_22 <= 8'd1;
			address2_23 <= 8'd1;
			address2_24 <= 8'd1;
			address2_31 <= 8'd2;
			address2_32 <= 8'd2;
			address2_33 <= 8'd2;
			address2_34 <= 8'd2;
			address2_41 <= 8'd3;
			address2_42 <= 8'd3;
			address2_43 <= 8'd3;
			address2_44 <= 8'd3;
		end
	end
	
endmodule
