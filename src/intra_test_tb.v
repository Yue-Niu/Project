//This is a testbench for intra_test
`timescale 1ns/1ps
module intra_test_tb;
	reg			clk;
	reg			rst_n;
	reg			vh_i;
	reg			angle_or_planar;
	reg [2:0]	PU;
	reg [5:0]	MODE;
	
	reg [8:0]	address1;
	
	wire			en_top,en_left;
	//wire [7:0]	ref_top_f0,ref_top_f1,ref_top_f2,ref_top_f3,ref_top_f4,ref_top_f5,ref_top_f6,ref_top_f7;
	//wire [7:0]	ref_left_f0,ref_left_f1,ref_left_f2,ref_left_f3,ref_left_f4,ref_left_f5,ref_left_f6,ref_left_f7;

	
	// clock
	initial
	begin
		#0	clk = 1'b1;
		forever
		#10	clk = ~clk;
	end
	
	//rst_n
	initial
	begin
	#5		rst_n = 1'b0;
	#10	rst_n = 1'b1;
	end
	
	//vh_i
	initial
	begin
		vh_i = 1'b1;
	end
	
	//PU
	initial
	begin
		PU = 3'd0;
	end
	
	//MODE
	initial
	begin
		MODE = 6'd1;
	end
	
	//negetive_flag
	/*initial
	begin
		#0	negetive_flag = 1'b0;
	end*/
	
	//address
	reg [3:0]  count;
	always @(posedge clk or negedge rst_n)
	begin
	  if(rst_n==1'b0)
	  begin
	    address1 <= 9'd0;
	    count <= 4'd0;
	  end
	  else
	  begin
	    if(count==4'd12)
	    begin
	      address1 <= address1 + 1'b1;
	      count <= 4'd0;
	    end
	    else
	    begin
	       count <= count + 1'b1;
	    end
	  end
	end
	
	//initiate module into test bencn
	wire [7:0]	pred_out11,pred_out12,pred_out13,pred_out14,
					pred_out21,pred_out22,pred_out23,pred_out24,
					pred_out31,pred_out32,pred_out33,pred_out34,
					pred_out41,pred_out42,pred_out43,pred_out44;
	intra_test intra_test_u(
		.clk(clk),
		.rst_n(rst_n),
		.vh_i(vh_i),
		.PU(PU),
		.MODE(MODE),
		
		.en_top(en_top),
		.en_left(en_left),
		.pred_out11(pred_out11),
		.pred_out12(pred_out12),
		.pred_out13(pred_out13),
		.pred_out14(pred_out14),
		.pred_out21(pred_out21),
		.pred_out22(pred_out22),
		.pred_out23(pred_out23),
		.pred_out24(pred_out24),
		.pred_out31(pred_out31),
		.pred_out32(pred_out32),
		.pred_out33(pred_out33),
		.pred_out34(pred_out34),
		.pred_out41(pred_out41),
		.pred_out42(pred_out42),
		.pred_out43(pred_out43),
		.pred_out44(pred_out44)
		);
		
	// end simulation
	initial
	begin
		#4000	$stop;
	end
endmodule
