//这个模块主要相当于输出参考像素的一个缓存
module LEFT_REF_BUFFER
(
	input		CLK,
	input		RST_n,
	input 	preset,
	
	input		EN_LEFT,
	
	input	[7:0]			REF_DATA,
	
	output reg[7:0]  	REF_LEFT0,
	output reg[7:0]	REF_LEFT1,
	output reg[7:0]	REF_LEFT2,
	output reg[7:0]	REF_LEFT3,
	output reg[7:0]	REF_LEFT4,
	output reg[7:0]	REF_LEFT5,
	output reg[7:0]	REF_LEFT6,
	output reg[7:0]	REF_LEFT7
);

	reg [2:0] count;
	always @(posedge CLK or negedge RST_n or posedge preset)
	begin
		if(RST_n==1'b0)
		begin
			REF_LEFT0 <= 8'd0;
			REF_LEFT1 <= 8'd0;
			REF_LEFT2 <= 8'd0;
			REF_LEFT3 <= 8'd0;
			REF_LEFT4 <= 8'd0;
			REF_LEFT5 <= 8'd0;
			REF_LEFT6 <= 8'd0;
			REF_LEFT7 <= 8'd0;
			
			count <= 3'd0;
		end
		else if(preset==1'b1)
			count <= 3'd0;
		else
		begin
			if(EN_LEFT)
			begin
				case(count)
				3'd0:
					REF_LEFT0 <= REF_DATA;
				3'd1:
					REF_LEFT1 <= REF_DATA;
				3'd2:
					REF_LEFT2 <= REF_DATA;
				3'd3:
					REF_LEFT3 <= REF_DATA;
				3'd4:
					REF_LEFT4 <= REF_DATA;
				3'd5:
					REF_LEFT5 <= REF_DATA;
				3'd6:
					REF_LEFT6 <= REF_DATA;
				default:
					REF_LEFT7 <= REF_DATA;
				endcase
				count <= count + 1'b1;
			end
			else
				count <= 3'd0;
		end
	end
	
endmodule
