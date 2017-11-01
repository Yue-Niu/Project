// 这个模块是DC预测的核心计算模块
module DC_PRED_UNIT
(
	input [2:0]PU,
	input LEFT_VALID,
	input TOP_VALID,
	input DCVAL_flag,
	
	input [7:0] TOP_REF0,
	input [7:0] TOP_REF1,
	input [7:0] TOP_REF2,
	input [7:0] TOP_REF3,
	
	input [7:0]	LEFT_REF0,
	input [7:0]	LEFT_REF1,
	input [7:0]	LEFT_REF2,
	input [7:0]	LEFT_REF3,
	
	output [7:0] PRED_OUT11,
	output [7:0] PRED_OUT12,
	output [7:0] PRED_OUT13,
	output [7:0] PRED_OUT14,
	output [7:0] PRED_OUT21,
	output [7:0] PRED_OUT22,
	output [7:0] PRED_OUT23,
	output [7:0] PRED_OUT24,
	output [7:0] PRED_OUT31,
	output [7:0] PRED_OUT32,
	output [7:0] PRED_OUT33,
	output [7:0] PRED_OUT34,
	output [7:0] PRED_OUT41,
	output [7:0] PRED_OUT42,
	output [7:0] PRED_OUT43,
	output [7:0] PRED_OUT44
);

	wire [9:0] TOP_ADD, LEFT_ADD;
	
	assign TOP_ADD = {2'b00,TOP_REF0} + {2'b00,TOP_REF1} + {2'b00,TOP_REF2} + {2'b00,TOP_REF3};
	assign LEFT_ADD = {2'b00,LEFT_REF0} + {2'b00,LEFT_REF1} + {2'b00,LEFT_REF2} + {2'b00,LEFT_REF3};
	
	reg [7:0] DC_VAL;
	reg [14:0] ADD_ACCUM,ADD_ACCUM_SHFT;
	always @(PU or LEFT_VALID or TOP_VALID or DCVAL_flag or TOP_ADD or LEFT_ADD)
	begin
		if(LEFT_VALID==1'b1 && TOP_VALID==1'b1 && DCVAL_flag==1'b1)
		begin
			ADD_ACCUM <= {5'd0,TOP_ADD} + {5'd0,LEFT_ADD};
			ADD_ACCUM_SHFT <= ADD_ACCUM>>3;
			DC_VAL <= ADD_ACCUM_SHFT[7:0];
		end
		else if(LEFT_VALID==1'b1 && TOP_VALID==1'b0 && DCVAL_flag==1'b0)
		begin
			ADD_ACCUM <= ADD_ACCUM + {5'd0,LEFT_ADD};
			ADD_ACCUM_SHFT <= 15'd0;
			DC_VAL = 8'd0;
		end
		else if(LEFT_VALID==1'b0 && TOP_VALID==1'b1 && DCVAL_flag==1'b0)
		begin
			ADD_ACCUM <= ADD_ACCUM + {5'd0,TOP_ADD};
			ADD_ACCUM_SHFT <= 15'd0;
			DC_VAL <= 8'd0;
		end
		else
		begin
			if(DCVAL_flag==1'b1)
			begin
				case(PU)
					3'd1:
						ADD_ACCUM_SHFT <= ADD_ACCUM >>4;
					3'd2:
						ADD_ACCUM_SHFT <= ADD_ACCUM >>5;
					3'd3:
						ADD_ACCUM_SHFT <= ADD_ACCUM >>6;
					default:
						ADD_ACCUM_SHFT <= ADD_ACCUM >>7;
				endcase
				DC_VAL <= ADD_ACCUM_SHFT[7:0];
				ADD_ACCUM <= 15'd0;
			end
			else
			begin
				ADD_ACCUM <= ADD_ACCUM;
				ADD_ACCUM_SHFT <= 15'd0;
				DC_VAL <= 8'd0;
			end
		end
	end
	
	reg [9:0] pred_o11,pred_o12,pred_o13,pred_o14,
				 pred_o21,pred_o22,pred_o23,pred_o24,
				 pred_o31,pred_o32,pred_o33,pred_o34,
				 pred_o41,pred_o42,pred_o43,pred_o44;
	always @(LEFT_VALID or TOP_VALID or DC_VAL or
			  TOP_REF0 or TOP_REF1 or TOP_REF2 or TOP_REF3 or
			  LEFT_REF0 or LEFT_REF1 or LEFT_REF2 or LEFT_REF3)
	begin
		if(LEFT_VALID==1'b1 && TOP_VALID==1'b1)
		begin
			pred_o11 <= ({2'b00,LEFT_REF0} + {2'b00,TOP_REF0} + {1'b0,DC_VAL,1'b0}+10'd2) >>2;
			pred_o12 <= ({2'b00,TOP_REF1} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o13 <= ({2'b00,TOP_REF2} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o14 <= ({2'b00,TOP_REF3} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o21 <= ({2'b00,LEFT_REF1} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o31 <= ({2'b00,LEFT_REF2} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o41 <= ({2'b00,LEFT_REF3} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
		end
		else if(TOP_VALID==1'b1 && TOP_VALID==1'b0)
		begin
			pred_o11 <= ({2'b00,TOP_REF0} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o12 <= ({2'b00,TOP_REF1} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o13 <= ({2'b00,TOP_REF2} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o14 <= ({2'b00,TOP_REF3} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o21 <= {2'b0,DC_VAL};
			pred_o31 <= {2'b0,DC_VAL};
			pred_o41 <= {2'b0,DC_VAL};
		end
		else if(TOP_VALID==1'b0 && LEFT_VALID==1'b1)
		begin
			pred_o11 <= ({2'b00,LEFT_REF0} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o21 <= ({2'b00,LEFT_REF1} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o31 <= ({2'b00,LEFT_REF2} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o41 <= ({2'b00,LEFT_REF3} + {1'b0,DC_VAL,1'b0} + {2'b00,DC_VAL}+10'd2) >>2;
			pred_o12 <= {2'b0,DC_VAL};
			pred_o13 <= {2'b0,DC_VAL};
			pred_o14 <= {2'b0,DC_VAL};
		end
		else
		begin
			pred_o11 <= {2'b0,DC_VAL};
			pred_o12 <= {2'b0,DC_VAL};
			pred_o13 <= {2'b0,DC_VAL};
			pred_o14 <= {2'b0,DC_VAL};
			pred_o21 <= {2'b0,DC_VAL};
			pred_o31 <= {2'b0,DC_VAL};
			pred_o41 <= {2'b0,DC_VAL};
		end
		pred_o22 <= {2'b0,DC_VAL};
		pred_o23 <= {2'b0,DC_VAL};
		pred_o24 <= {2'b0,DC_VAL};
		pred_o32 <= {2'b0,DC_VAL};
		pred_o33 <= {2'b0,DC_VAL};
		pred_o34 <= {2'b0,DC_VAL};
		pred_o42 <= {2'b0,DC_VAL};
		pred_o43 <= {2'b0,DC_VAL};
		pred_o44 <= {2'b0,DC_VAL};
	end
	
	assign PRED_OUT11 = pred_o11[7:0];
	assign PRED_OUT12 = pred_o12[7:0];
	assign PRED_OUT13 = pred_o13[7:0];
	assign PRED_OUT14 = pred_o14[7:0];
	assign PRED_OUT21 = pred_o21[7:0];
	assign PRED_OUT22 = pred_o22[7:0];
	assign PRED_OUT23 = pred_o23[7:0];
	assign PRED_OUT24 = pred_o24[7:0];
	assign PRED_OUT31 = pred_o31[7:0];
	assign PRED_OUT32 = pred_o32[7:0];
	assign PRED_OUT33 = pred_o33[7:0];
	assign PRED_OUT34 = pred_o34[7:0];
	assign PRED_OUT41 = pred_o41[7:0];
	assign PRED_OUT42 = pred_o42[7:0];
	assign PRED_OUT43 = pred_o43[7:0];
	assign PRED_OUT44 = pred_o44[7:0];
endmodule
