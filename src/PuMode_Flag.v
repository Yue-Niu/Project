/*
	这个模块由输入的PU和MODE信号来确定哪些是负角度预测，哪些需要滤波
*/
module PuMode_Flag
(
	input [2:0]		PU,
	input	[5:0]		MODE,
	
	output reg		filter_flag,
	output reg		negetive_pred,
	output reg 		angle_or_planar,
	output reg 		DC_flag
);

	always @(PU or MODE)
	begin
		case(PU)
			3'd0:
			begin
				filter_flag = 1'b0;
			end
			3'd1:
			begin
				case(MODE)
					6'd2,6'd18,6'd34:
						filter_flag = 1'b1;
					default:
						filter_flag = 1'b0;
				endcase
			end
			3'd2:
			begin
				case(MODE)
					6'd9,6'd10,6'd11,6'd25,6'd26,6'd27:
						filter_flag = 1'b0;
					default:
						filter_flag = 1'b1;
				endcase
			end
			3'd3:
			begin
				case(MODE)
					6'd10,6'd26:
						filter_flag = 1'b0;
					default:
						filter_flag = 1'b1;
				endcase
			end
			default:
			begin
				filter_flag = 1'b0;
			end
		endcase
	end
	
	always @(MODE)
	begin
		case(MODE)
			6'd11,6'd12,6'd13,6'd14,6'd15,6'd16,6'd17,6'd18,6'd19,6'd20,6'd21,6'd22,6'd23,6'd24,6'd25:
				negetive_pred = 1'b1;
			default:
				negetive_pred = 1'b0;
		endcase
	end
	
	always @(MODE)
	begin
		case(MODE)
			6'd0:
			begin
				angle_or_planar = 1'b0;
				DC_flag = 1'b0;
			end
			6'd1:
			begin
				angle_or_planar = 1'b0;
				DC_flag = 1'b1;
			end
			default:
			begin
				angle_or_planar = 1'b1;
				DC_flag = 1'b0;
			end
		endcase
	end
endmodule
