//这个模块主要相当于输出参考像素的一个缓存
module TOP_REF_BUFFER
(
	input		CLK,
	input		RST_n,
	input 	preset,
	
	input		EN_TOP,
	
	input	[7:0]			REF_DATA,
	
	output reg[7:0]  	REF_TOP0,
	output reg[7:0]	REF_TOP1,
	output reg[7:0]	REF_TOP2,
	output reg[7:0]	REF_TOP3,
	output reg[7:0]	REF_TOP4,
	output reg[7:0]	REF_TOP5,
	output reg[7:0]	REF_TOP6,
	output reg[7:0]	REF_TOP7
);

	reg [2:0] count;
	always @(posedge CLK or negedge RST_n or posedge preset)
	begin
		if(RST_n==1'b0)
		begin
			REF_TOP0 <= 8'd0;
			REF_TOP1 <= 8'd0;
			REF_TOP2 <= 8'd0;
			REF_TOP3 <= 8'd0;
			REF_TOP4 <= 8'd0;
			REF_TOP5 <= 8'd0;
			REF_TOP6 <= 8'd0;
			REF_TOP7 <= 8'd0;
			
			count <= 3'd0;
		end
		else if(preset==1'b1)
			count <= 3'd0;
		else
		begin
			if(EN_TOP)
			begin
				case(count)
				3'd1:
					REF_TOP0 <= REF_DATA;
				3'd2:
					REF_TOP1 <= REF_DATA;
				3'd3:
					REF_TOP2 <= REF_DATA;
				3'd4:
					REF_TOP3 <= REF_DATA;
				3'd5:
					REF_TOP4 <= REF_DATA;
				3'd6:
					REF_TOP5 <= REF_DATA;
				3'd7:
					REF_TOP6 <= REF_DATA;
				default:
					REF_TOP7 <= REF_DATA;
				endcase
				count <= count + 1'b1;
			end
			else
			begin
				count <= 3'd0;
			end
		end
	end

endmodule	