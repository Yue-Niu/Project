module ADDRESS_ABITRATE_DC
(
	input CLK_HIGH,
	input RST_n,
	input preset_flag,
	
	input [5:0]	X,
	input [5:0]	Y,
	
	output reg[7:0] ADDR,
	
	output reg EN_LEFT,
	output reg EN_TOP
);

	wire [7:0] X_end,Y_end;
	assign X_end = {2'b00,X} + 8'd4;
	assign Y_end = {2'b00,Y} + 8'd4;
	
	always @(posedge CLK_HIGH or negedge RST_n)
	begin
		if(RST_n==1'b0)
		begin
			ADDR <= 8'd0;
			EN_LEFT <= 1'b0;
			EN_TOP <= 1'b0;
		end
		else
		begin
			if(preset_flag==1'b1)
			begin
				ADDR <= {3'd0,Y}+8'd1;
				EN_LEFT <= 1'b1;
				EN_TOP <= 1'b0;
			end
			else
			begin
				if(ADDR==Y_end && EN_LEFT==1'b1)
				begin
					ADDR <= {3'd0,X}+8'd1;
					EN_LEFT <= 1'b0;
					EN_TOP <= 1'b1;
				end
				else if(ADDR==X_end && EN_TOP==1'b1)
				begin
					ADDR <= 8'd0;
					EN_LEFT <= 1'b0;
					EN_TOP <= 1'b1;
				end
				else
					ADDR <= ADDR + 1'b1;
			end
		end
	end
	
endmodule
