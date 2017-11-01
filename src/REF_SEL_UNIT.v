/*
	这个模块是对应一个预测像素的选择像素模块
*/
module REF_SEL_UNIT
(
	input [7:0]		REF_TOP0,
	input [7:0]		REF_TOP1,
	input [7:0]		REF_TOP2,
	input [7:0]		REF_TOP3,
	input [7:0]		REF_TOP4,
	input [7:0]		REF_TOP5,
	input [7:0]		REF_TOP6,
	input [7:0]		REF_TOP7,
	
	input [7:0]		REF_TOP0a,
	input [7:0]		REF_TOP1a,
	input [7:0]		REF_TOP2a,
	input [7:0]		REF_TOP3a,
	input [7:0]		REF_TOP4a,
	input [7:0]		REF_TOP5a,
	input [7:0]		REF_TOP6a,
	input [7:0]		REF_TOP7a,
	
	input [7:0]		REF_LEFT0,
	input [7:0]		REF_LEFT1,
	input [7:0]		REF_LEFT2,
	input [7:0]		REF_LEFT3,
	input [7:0]		REF_LEFT4,
	input [7:0]		REF_LEFT5,
	input [7:0]		REF_LEFT6,
	input [7:0]		REF_LEFT7,
	
	input [7:0]		REF_LEFT0a,
	input [7:0]		REF_LEFT1a,
	input [7:0]		REF_LEFT2a,
	input [7:0]		REF_LEFT3a,
	input [7:0]		REF_LEFT4a,
	input [7:0]		REF_LEFT5a,
	input [7:0]		REF_LEFT6a,
	input [7:0]		REF_LEFT7a,
	
	input				TOP_or_LEFT1,
	input				TOP_or_LEFT2,
	
	input	[7:0]		ADDR_R1,
	input [7:0]		ADDR_R2,
	
	output reg[7:0]	REF1,
	output reg[7:0]	REF2,
	
	output reg[7:0]	REF1a,
	output reg[7:0]	REF2a
);

	reg [7:0]	top1,top2,left1,left2;
	reg [7:0]	top1a,top2a,left1a,left2a;
	always @(REF_TOP0 or REF_TOP1 or REF_TOP2 or REF_TOP3 or REF_TOP4 or REF_TOP5 or REF_TOP6 or REF_TOP7 or
				REF_TOP0a or REF_TOP1a or REF_TOP2a or REF_TOP3a or REF_TOP4a or REF_TOP5a or REF_TOP6a or REF_TOP7a or
	         REF_LEFT0 or REF_LEFT1 or REF_LEFT2 or REF_LEFT3 or REF_LEFT4 or REF_LEFT5 or REF_LEFT6 or REF_LEFT7 or
				REF_LEFT0a or REF_LEFT1a or REF_LEFT2a or REF_LEFT3a or REF_LEFT4a or REF_LEFT5a or REF_LEFT6a or REF_LEFT7a or
				ADDR_R1 or ADDR_R2)
	begin
	case(ADDR_R1)
		8'd0:
		begin
			top1 = REF_TOP0;
			top1a = REF_TOP0a;
			//top2 = REF_TOP1;
			left1 = REF_LEFT0;
			left1a = REF_LEFT0a;
			//left2 = REF_LEFT1;
		end
		8'd1:
		begin
			top1 = REF_TOP1;
			top1a = REF_TOP1a;
			//top2 = REF_TOP2;
			left1 = REF_LEFT1;
			left1a = REF_LEFT1a;
			//left2 = REF_LEFT2;
		end
		8'd2:
		begin
			top1 = REF_TOP2;
			top1a = REF_TOP2a;
			//top2 = REF_TOP3;
			left1 = REF_LEFT2;
			left1a = REF_LEFT2a;
			//left2 = REF_LEFT3;
		end
		8'd3:
		begin
			top1 = REF_TOP3;
			top1a = REF_TOP3a;
			//top2 = REF_TOP4;
			left1 = REF_LEFT3;
			left1a = REF_LEFT3a;
			//left2 = REF_LEFT4;
		end
		8'd4:
		begin
			top1 = REF_TOP4;
			top1a = REF_TOP4a;
			//top2 = REF_TOP5;
			left1 = REF_LEFT4;
			left1a = REF_LEFT4a;
			//left2 = REF_LEFT5;
		end
		8'd5:
		begin
			top1 = REF_TOP5;
			top1a = REF_TOP5a;
			//top2 = REF_TOP6;
			left1 = REF_LEFT5;
			left1a = REF_LEFT5a;
			//left2 = REF_LEFT6;
		end
		8'd6:
		begin
			top1 = REF_TOP6;
			top1a = REF_TOP6a;
			//top2 = REF_TOP7;
			left1 = REF_LEFT6;
			left1a = REF_LEFT6a;
			//left2 = REF_LEFT7;
		end
		default:
		begin
			top1 = REF_TOP7;
			top1a = REF_TOP7a;
			//top2 = REF_TOP7;
			left1 = REF_LEFT7;
			left1a = REF_LEFT7a;
			//left2 = REF_LEFT7;
		end
	endcase
	
	case(ADDR_R2)
		8'd0:
		begin
			//top1 = REF_TOP0;
			top2 = REF_TOP0;
			top2a = REF_TOP0a;
			//left1 = REF_LEFT0;
			left2 = REF_LEFT0;
			left2a = REF_LEFT0a;
		end
		8'd1:
		begin
			//top1 = REF_TOP1;
			top2 = REF_TOP1;
			top2a = REF_TOP1a;
			//left1 = REF_LEFT1;
			left2 = REF_LEFT1;
			left2a = REF_LEFT1a;
		end
		8'd2:
		begin
			//top1 = REF_TOP2;
			top2 = REF_TOP2;
			top2a = REF_TOP2a;
			//left1 = REF_LEFT2;
			left2 = REF_LEFT2;
			left2a = REF_LEFT2a;
		end
		8'd3:
		begin
			//top1 = REF_TOP3;
			top2 = REF_TOP3;
			top2a = REF_TOP3a;
			//left1 = REF_LEFT3;
			left2 = REF_LEFT3;
			left2a = REF_LEFT3a;
		end
		8'd4:
		begin
			//top1 = REF_TOP4;
			top2 = REF_TOP4;
			top2a = REF_TOP4a;
			//left1 = REF_LEFT4;
			left2 = REF_LEFT4;
			left2a = REF_LEFT4a;
		end
		8'd5:
		begin
			//top1 = REF_TOP5;
			top2 = REF_TOP5;
			top2a = REF_TOP5a;
			//left1 = REF_LEFT5;
			left2 = REF_LEFT5;
			left2a = REF_LEFT5a;
		end
		8'd6:
		begin
			//top1 = REF_TOP6;
			top2 = REF_TOP6;
			top2a = REF_TOP6a;
			//left1 = REF_LEFT6;
			left2 = REF_LEFT6;
			left2a = REF_LEFT6a;
		end
		default:
		begin
			//top1 = REF_TOP7;
			top2 = REF_TOP7;
			top2a = REF_TOP7a;
			//left1 = REF_LEFT7;
			left2 = REF_LEFT7;
			left2a = REF_LEFT7a;
		end
	endcase
	end
	
	always @(top1 or top2 or left1 or left2 or TOP_or_LEFT1 or TOP_or_LEFT2 or top1a or top2a or left1a or left2a)
	begin
		if(TOP_or_LEFT1==1'b1)
		begin
			REF1 = top1;
			REF1a = top1a;
			//REF2 = top2;
		end
		else
		begin
			REF1 = left1;
			REF1a = left1a;
			//REF2 = left2;
		end
		
		if(TOP_or_LEFT2==1'b1)
		begin
			REF2 = top2;
			REF2a = top2a;
		end
		else
		begin
			REF2 = left2;
			REF2a = left2a;
		end
	end
	
endmodule
