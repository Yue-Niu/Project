//This module decide select top or left reference pixels
module address_abitrate
(
	input 			clk,
	input				rst_n,
	input				vh_i,
	input				preset_flag,
	input				negetive_pred,
	input				negetive_flag,
	
	input 			top_or_left11,
	input 			top_or_left14,
	input 			top_or_left41,
	input 			top_or_left44,
	
	input [7:0]		address11,
	input [7:0]		address14,
	input [7:0]		address41,
	input [7:0]		address44,
	
	output reg[7:0]	address_RAM,
	
	output reg	en_top,
	output reg	en_left
);

	always @(posedge clk or negedge rst_n)
	begin
		if(~rst_n)
		begin
			address_RAM <= 8'd0;
			en_top <= 1'b0;
			en_left <= 1'b0;
			//finish <= 1'b0;
		end
		else 
		begin
			//if(preset_flag==1'b1)
			//begin
				if(negetive_flag==1'b0 && negetive_pred==1'b0)
					address_RAM <= address11;
				else if(negetive_flag==1'b0 && negetive_pred==1'b1)
					address_RAM <= vh_i==1'b1 ? address41 : address14;
				else
					address_RAM <= 8'd0;
			if(preset_flag==1'b1)
			begin
				if(vh_i==1'b1)
				begin
					en_top <= 1'b1;
					en_left <= 1'b0;
				end
				else
				begin
					en_top <= 1'b0;
					en_left <= 1'b1;
				end
			end
			else
			begin
				if(negetive_pred==1'b1 && vh_i==1'b1)
				begin
					//finish <= 1'b0;
					if(address_RAM==address14+8'd2)
					begin
						address_RAM <= 8'd0;
						en_top <= 1'b0;
					end
					else
						address_RAM <= address_RAM + 1'b1;
				end
				else if(negetive_pred==1'b1 && vh_i==1'b0)
				begin
					if(address_RAM==address41+8'd2)
					begin
						address_RAM <= 8'd0;
						en_top <= 1'b0;
					end
					else
						address_RAM <= address_RAM + 1'b1;
				end
				else //if(negetive_flag==1'b1)
				begin
					//finish <= 1'b0;
					if(address_RAM==address44+8'd1 && en_top==1'b1)
					begin
						en_top <= 1'b0;
						en_left <= 1'b1;
						address_RAM <= 8'd0;
					end
					else if(address_RAM==address44+8'd1 && en_left==1'b1)
					begin
						address_RAM <= 8'd0;
						en_left <= 1'b0;
					end
					else
						address_RAM <= address_RAM + 1'b1;
				end
				/*else if(negetive_flag==1'b0)
				begin
					//finish <= 1'b0;
					if(address_RAM==address44)
					begin
						address_RAM <= 8'd0;
						//finish <= 1'b1;
					end
					else
					begin
						address_RAM <= address_RAM + 1'b1;
					end
				end
				else
				begin
					if(address_RAM==address41 && en_left==1'b1)
					begin
						en_top <= 1'b1;
						en_left <= 1'b0;
						address_RAM <= 8'd0;
					end
					else if(address_RAM==address14 && en_top==1'b1)
					begin
						address_RAM <= 8'd0;
					end
					else
					begin
						address_RAM <= address_RAM + 1'b1;
					end
				end*/
			end
		end
	end

	
	endmodule
	
