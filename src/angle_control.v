//This moduel is a controller for angle prediction
module angle_control
(
   input clk,
   input rst_n,
	input restart,
  
	output reg	en1,
	output reg	en2
);

	//state define
	parameter idle = 3'd0,S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4;
   //state
   reg [2:0] cs,ns;
	
	always @(posedge clk or negedge rst_n)
	begin
		if(~rst_n)
		begin
			cs = idle;
		end
		else
		begin
			cs = ns;
		end
	end
	
	always @(cs)
	begin
		ns = idle;
		case(cs)
		idle:
		begin
			ns = S1;
		end
		S1:
		begin
			ns = S2;
		end
		S2:
		begin
			ns = S3;
		end
		S3:
		begin
			ns = S4;
		end
		S4:
		begin
			if(restart)
			begin
				ns = idle;
			end
			else
			begin
				ns = S3;
			end
		end
		endcase
	end
	
	always @(posedge clk or negedge rst_n)
	begin
		if(~rst_n)
		begin
			en1 = 1'b0;
			en2 = 1'b0;
		end
		else
		begin
			case(cs)
			idle:
			begin
				en1 = 1'b0;
				en2 = 1'b0;
			end
			S1:
			begin
				en1 = 1'b0;
				en2 = 1'b0;
			end
			S2:
			begin
				en1 = 1'b1;
				en2 = 1'b0;
			end
			S3:
			begin
				en1 = 1'b1;
				en2 = 1'b1;
			end
			S4:
			begin
				en1 = 1'b1;
				en2 = 1'b1;
			end
			endcase
		end
	end

endmodule
