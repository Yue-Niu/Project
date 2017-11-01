//This module is a controller for address generation
module address_gen_control
(
	input			clk,
	input   finish,
	input			rst_n,
	input			en1,
	
	output reg preset_flag
);

	parameter	idle = 2'd0, S1 = 2'd1, S2 = 2'd2;
	
	reg [1:0]	cs, ns;
	
	always @(posedge clk or negedge rst_n)
	begin
		if(~rst_n)
		begin
			cs = idle;
		end
		else if(en1==1'b1)
		begin
			cs = ns;
		end
		else
		begin
			cs = idle;
		end
	end
	
	always @(cs or en1 or finish)
	begin
		ns = idle;
		case(cs)
		idle:
		begin
			ns = S1;
		end
		S1:
		begin
			if(en1==1'b1)
			begin
				ns = S2;
			end
			else
			begin
				ns = S1;
			end
		end
		S2:
		begin
			if(en1==1'b1 && finish==1'b0)
			begin
				ns = S2;
			end
			else if(en1==1'b1 && finish==1'b1)
			begin
			   ns = S1;
			end
			else
			begin
				ns = idle;
			end
		end
		endcase
	end
	
	always @(posedge clk or negedge rst_n)
	begin
		if(~rst_n)
		begin
			preset_flag = 1'b0;
		end
		else
		begin
			case(cs)
			idle:
			begin
				preset_flag = 1'b1;
			end
			S1:
			begin
				preset_flag = 1'b1;
			end
			S2:
			begin
				preset_flag = 1'b0;
			end
			endcase
		end
	end
endmodule
