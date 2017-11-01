// 这个模块对应的是Planar预测的address产生
module address_abitrate_planar
(
	input			CLK,
	input 		RST_n,
	input [2:0]	PU,
	input			preset_flag,
	
	input	[5:0]	X,
	input [5:0]	Y,
	input [7:0] TOP_RIGHT,
	input [7:0] BOTTOM_LEFT,
	
	output reg[7:0]	ADDRESS_RAM,
	
	output reg EN_TOP,
	output reg EN_LEFT
);

	wire [7:0] X_end,Y_end;
	
	assign X_end = {2'b00,X} + 8'd3;
	assign Y_end = {2'b00,Y} + 8'd3;
	

	reg top_flag,left_flag;
	always @(posedge CLK or negedge RST_n)
	begin
		if(RST_n==1'b0)
		begin
			ADDRESS_RAM <= 8'd0;
			EN_TOP <= 1'b0;
			EN_LEFT <= 1'b0;
			top_flag <= 1'b0;
			left_flag <= 1'b0;
		end
		else
		begin
			if(preset_flag==1'b1)
			begin
				ADDRESS_RAM <= {2'b00,X};
				EN_TOP <= 1'b1;
				EN_LEFT <= 1'b0;
				top_flag <= 1'b1;
				left_flag <= 1'b0;
			end
			else
			begin
				if(ADDRESS_RAM==X_end && top_flag==1'b1)
				begin
					ADDRESS_RAM <= TOP_RIGHT;
					EN_TOP <= 1'b1;
					EN_LEFT <= 1'b0;
					top_flag <= 1'b1;
					left_flag <= 1'b0;
				end
				else if(ADDRESS_RAM==TOP_RIGHT && top_flag==1'b1)
				begin
					ADDRESS_RAM <= {2'b00,Y};
					EN_TOP <= 1'b1;
					EN_LEFT <= 1'b0;
					top_flag <= 1'b0;
					left_flag <= 1'b1;
				end
				else if(ADDRESS_RAM==Y && top_flag==1'b0)
				begin
					ADDRESS_RAM <= ADDRESS_RAM + 1'b1;
					EN_TOP <= 1'b0;
					EN_LEFT <= 1'b1;
					top_flag <= 1'b0;
					left_flag <= 1'b1;
				end
				else if(ADDRESS_RAM==Y_end && left_flag==1'b1)
				begin
					ADDRESS_RAM <= BOTTOM_LEFT;
					EN_TOP <= 1'b0;
					EN_LEFT <= 1'b1;
					top_flag <= 1'b0;
					left_flag <= 1'b1;
				end
				else if(ADDRESS_RAM==BOTTOM_LEFT && left_flag==1'b1)
				begin
					ADDRESS_RAM <= 8'd0;
					EN_TOP <= 1'b0;
					EN_LEFT <= 1'b1;
					top_flag <= 1'b0;
					left_flag <= 1'b0;
				end
				else if(ADDRESS_RAM==8'd0 && left_flag==1'b0)
				begin
					ADDRESS_RAM <= 8'd0;
					EN_TOP <= 1'b0;
					EN_LEFT <= 1'b0;
					top_flag <= 1'b0;
					left_flag <= 1'b0;
				end
				else
					ADDRESS_RAM <= ADDRESS_RAM + 1'b1;
			end
		end
	end
	
endmodule
