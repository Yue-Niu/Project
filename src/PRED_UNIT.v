/*
	这个模块就是角度预测计算的核心模块，其中是完全没有用到乘法器的，
	都是用移位和加法器的组合
*/
module PRED_UNIT
(
	input [2:0] PU,
	input angle_or_planar,
	input	[7:0]	WEIGHT1,
	input [7:0] WEIGHT2,
	
	input	[7:0]	REF1,
	input [7:0]	REF2,
	
	input [7:0] REF1a,
	input [7:0] REF2a,
	
	output [7:0] PRED_OUT
);

/*
	下面的模块就是化乘法为加法和移位的核心模块
	手稿1页
*/
	//REF1
	wire [13:0]	REF1_0,REF1_1,REF1_2,REF1_3,REF1_4,REF1_5;
	wire [13:0]	REF1_MUX0,REF1_MUX1,REF1_MUX2,REF1_MUX3,REF1_MUX4,REF1_MUX5;
	wire [13:0]	REF1_MUL;
	
	assign REF1_0 = {6'd0,REF1};
	assign REF1_1 = {5'd0,REF1,1'd0};
	assign REF1_2 = {4'd0,REF1,2'd0};
	assign REF1_3 = {3'd0,REF1,3'd0};
	assign REF1_4 = {2'd0,REF1,4'd0};
	assign REF1_5 = {1'd0,REF1,5'd0};
	
	assign REF1_MUX0 = WEIGHT1[0]==1 ? REF1_0 : 14'd0;
	assign REF1_MUX1 = WEIGHT1[1]==1 ? REF1_1 : 14'd0;
	assign REF1_MUX2 = WEIGHT1[2]==1 ? REF1_2 : 14'd0;
	assign REF1_MUX3 = WEIGHT1[3]==1 ? REF1_3 : 14'd0;
	assign REF1_MUX4 = WEIGHT1[4]==1 ? REF1_4 : 14'd0;
	assign REF1_MUX5 = WEIGHT1[5]==1 ? REF1_5 : 14'd0;
	
	assign REF1_MUL = REF1_MUX0 + REF1_MUX1 + REF1_MUX2 + REF1_MUX3 + REF1_MUX4 + REF1_MUX5;
	
	//REF2
	wire [13:0]	REF2_0,REF2_1,REF2_2,REF2_3,REF2_4,REF2_5;
	wire [13:0]	REF2_MUX0,REF2_MUX1,REF2_MUX2,REF2_MUX3,REF2_MUX4,REF2_MUX5;
	wire [13:0]	REF2_MUL;
	
	assign REF2_0 = {6'd0,REF2};
	assign REF2_1 = {5'd0,REF2,1'd0};
	assign REF2_2 = {4'd0,REF2,2'd0};
	assign REF2_3 = {3'd0,REF2,3'd0};
	assign REF2_4 = {2'd0,REF2,4'd0};
	assign REF2_5 = {1'd0,REF2,5'd0};
	
	assign REF2_MUX0 = WEIGHT2[0]==1 ? REF2_0 : 14'd0;
	assign REF2_MUX1 = WEIGHT2[1]==1 ? REF2_1 : 14'd0;
	assign REF2_MUX2 = WEIGHT2[2]==1 ? REF2_2 : 14'd0;
	assign REF2_MUX3 = WEIGHT2[3]==1 ? REF2_3 : 14'd0;
	assign REF2_MUX4 = WEIGHT2[4]==1 ? REF2_4 : 14'd0;
	assign REF2_MUX5 = WEIGHT2[5]==1 ? REF2_5 : 14'd0;
	
	assign REF2_MUL = REF2_MUX0 + REF2_MUX1 + REF2_MUX2 + REF2_MUX3 + REF2_MUX4 + REF2_MUX5;
	
/*
	下面是角度预测和PLANAR预测的核心算法
*/
	reg [13:0]	N;
	always @(PU or angle_or_planar or REF1 or REF2 or REF1a or REF2a)
	begin
		if(angle_or_planar==1'b1)
		begin
			N = 14'd16;
		end
		else
		case(PU)
			3'd0:
			begin
				N = ({6'd0,REF1a} + {6'd0,REF2a} + 14'd1)<<2;
			end
			3'd1:
			begin
				N = ({6'd0,REF1a} + {6'd0,REF2a} + 14'd1)<<3;
			end
			3'd2:
			begin
				N = ({6'd0,REF1a} + {6'd0,REF2a} + 14'd1)<<4;
			end
			3'd3:
			begin
				N = ({6'd0,REF1a} + {6'd0,REF2a} + 14'd1)<<5;
			end
			default:
			begin
				N = ({6'd0,REF1a} + {6'd0,REF2a} + 14'd1)<<6;
			end
		endcase
	end
	
	reg [13:0] pred_out_buf;
	
	always @(PU or angle_or_planar or REF1_MUL or REF2_MUL or N)
	begin
		if(angle_or_planar==1'b1)
		begin
			pred_out_buf = (REF1_MUL + REF2_MUL + N)>>5;
		end
		else
		begin
			case(PU)
				3'd0:
				begin
					pred_out_buf = (REF1_MUL + REF2_MUL + N)>>3;
				end
				3'd1:
				begin
					pred_out_buf = (REF1_MUL + REF2_MUL + N)>>4;
				end
				3'd2:
				begin
					pred_out_buf = (REF1_MUL + REF2_MUL + N)>>5;
				end
				3'd3:
				begin
					pred_out_buf = (REF1_MUL + REF2_MUL + N)>>6;
				end
				default:
				begin
					pred_out_buf = (REF1_MUL + REF2_MUL + N)>>7;
				end
			endcase
		end
	end

	
	assign PRED_OUT = pred_out_buf[7:0];
	
endmodule
