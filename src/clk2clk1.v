//This module divide clk to clk1
module clk2clk1
(
	input			clk,
	input			rst_n,
	
	output reg	clk1,
	output reg  clk_vga
);

	// frequency division method
	reg [3:0]	count1;
	reg			High_Low;
	
	always @(posedge clk or negedge rst_n)
	begin
		if(rst_n==1'b0)
		begin
			count1 <= 4'd0;
			clk1 <= 1'b0;
			clk_vga <= 1'b0;
			High_Low <= 1'b0;
		end
		else
		begin
			clk_vga <= ~clk_vga;
			if(High_Low==1'b0)
			begin
				if(count1==4'd15)
				begin
					count1 <= 4'd0;
					clk1 <= 1'b1;
					High_Low <= 1'b1;
				end
				else
					count1 <= count1 + 1'b1;
			end
			else
			begin
				if(count1==4'd0)
				begin
					count1 <= 4'd0;
					clk1 <= 1'b0;
					High_Low <= 1'b0;
				end
				else
					count1 <= count1 + 1'b1;
			end
		end
	end
	
	/*always @(posedge clk or negedge rst_n)
	begin
	  if(rst_n==1'b0)
	  begin
	    count2 <= 4'd0;
	    finish <= 1'b0;
	  end
	  else
	  begin
	    if(count2==4'd11)
	    begin
	      count2 <= 4'd0;
	      finish = 1'b1;
	    end
	    else
	    begin
	      count2 <= count2 + 1'b1;
	      finish <= 1'b0;
	    end
	  end
	end*/
	
endmodule
