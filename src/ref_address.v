//In this module, we calculate the final address for
//reference selection
module ref_address
(
	input 				vh_i, //vertical or horizontal prediction
	input [7:0]			index1,
	input [7:0]			index2,
	input [7:0]			index3,
	input [7:0]			index4, //these are index from LUT
	
	input [7:0]			index_aux1,
	input [7:0]			index_aux2,
	input [7:0]			index_aux3,
	input [7:0]			index_aux4,
	
	input [7:0]			X,
	input [7:0]			Y, //these are location for current prediction block
	
	output 				top_or_left11,
	output 				top_or_left12,
	output 				top_or_left13,
	output 				top_or_left14,
	output 				top_or_left21,
	output 				top_or_left22,
	output 				top_or_left23,
	output 				top_or_left24,
	output 				top_or_left31,
	output 				top_or_left32,
	output 				top_or_left33,
	output 				top_or_left34,
	output 				top_or_left41,
	output 				top_or_left42,
	output 				top_or_left43,
	output				top_or_left44,
	
	output [7:0]	address11,
	output [7:0]	address12,
	output [7:0]	address13,
	output [7:0]	address14,
	output [7:0]	address21,
	output [7:0]	address22,
	output [7:0]	address23,
	output [7:0]	address24,
	output [7:0]	address31,
	output [7:0]	address32,
	output [7:0]	address33,
	output [7:0]	address34,
	output [7:0]	address41,
	output [7:0]	address42,
	output [7:0]	address43,
	output [7:0]	address44,
	
	output reg[7:0]	address11_R,
	output reg[7:0]	address12_R,
	output reg[7:0]	address13_R,
	output reg[7:0]	address14_R,
	output reg[7:0]	address21_R,
	output reg[7:0]	address22_R,
	output reg[7:0]	address23_R,
	output reg[7:0]	address24_R,
	output reg[7:0]	address31_R,
	output reg[7:0]	address32_R,
	output reg[7:0]	address33_R,
	output reg[7:0]	address34_R,
	output reg[7:0]	address41_R,
	output reg[7:0]	address42_R,
	output reg[7:0]	address43_R,
	output reg[7:0]	address44_R,
	
	output negetive_flag
);

	//first, add index and location according to prediction mode
	wire [7:0]	address_first11, address_first12, address_first13, address_first14,
					address_first21, address_first22, address_first23, address_first24,
					address_first31, address_first32, address_first33, address_first34,
					address_first41, address_first42, address_first43, address_first44;
	reg [7:0]	address11_Ra,address12_Ra,address13_Ra,address14_Ra,
					address21_Ra,address22_Ra,address23_Ra,address24_Ra,
					address31_Ra,address32_Ra,address33_Ra,address34_Ra,
					address41_Ra,address42_Ra,address43_Ra,address44_Ra;
	wire [7:0]	address11_Raa,address12_Raa,address13_Raa,address14_Raa,
					address21_Raa,address22_Raa,address23_Raa,address24_Raa,
					address31_Raa,address32_Raa,address33_Raa,address34_Raa,
					address41_Raa,address42_Raa,address43_Raa,address44_Raa;
	wire [7:0]	address_first11_r, address_first12_r, address_first13_r, address_first14_r,
					address_first21_r, address_first22_r, address_first23_r, address_first24_r,
					address_first31_r, address_first32_r, address_first33_r, address_first34_r,
					address_first41_r, address_first42_r, address_first43_r, address_first44_r;
	//wire [8:0]	X_E,Y_E;
	//assign X_E = {1'b0,X};
	//assign Y_E = {1'b0,Y};
	
	/*assign address_first11 = {1'b0,index1} + (vh_i==1'b1 ? X_E : Y_E);
	assign address_first12 = {1'b0,index1} + (vh_i==1'b1 ? X_E+9'd1 : Y_E);
	assign address_first13 = {1'b0,index1} + (vh_i==1'b1 ? X_E+9'd2 : Y_E);
	assign address_first14 = {1'b0,index1} + (vh_i==1'b1 ? X_E+9'd3 : Y_E);
	assign address_first21 = {1'b0,index2} + (vh_i==1'b1 ? X_E : Y_E+9'd1);
	assign address_first22 = {1'b0,index2} + (vh_i==1'b1 ? X_E+9'd1 : Y_E+9'd1);
	assign address_first23 = {1'b0,index2} + (vh_i==1'b1 ? X_E+9'd2 : Y_E+9'd1);
	assign address_first24 = {1'b0,index2} + (vh_i==1'b1 ? X_E+9'd3 : Y_E+9'd1);
	assign address_first31 = {1'b0,index3} + (vh_i==1'b1 ? X_E : Y_E+9'd2);
	assign address_first32 = {1'b0,index3} + (vh_i==1'b1 ? X_E+9'd1 : Y_E+9'd2);
	assign address_first33 = {1'b0,index3} + (vh_i==1'b1 ? X_E+9'd2 : Y_E+9'd2);
	assign address_first34 = {1'b0,index3} + (vh_i==1'b1 ? X_E+9'd3 : Y_E+9'd2);
	assign address_first41 = {1'b0,index4} + (vh_i==1'b1 ? X_E : Y_E+9'd3);
	assign address_first42 = {1'b0,index4} + (vh_i==1'b1 ? X_E+9'd1 : Y_E+9'd3);
	assign address_first43 = {1'b0,index4} + (vh_i==1'b1 ? X_E+9'd2 : Y_E+9'd3);
	assign address_first44 = {1'b0,index4} + (vh_i==1'b1 ? X_E+9'd3 : Y_E+9'd3);*/
	
	assign address_first11 = index1 + (vh_i==1'b1 ? X+8'd1 : Y+8'd1);
	assign address_first12 = index1 + (vh_i==1'b1 ? X+8'd2 : Y+8'd1);
	assign address_first13 = index1 + (vh_i==1'b1 ? X+8'd3 : Y+8'd1);
	assign address_first14 = index1 + (vh_i==1'b1 ? X+8'd4 : Y+8'd1);
	assign address_first21 = index2 + (vh_i==1'b1 ? X+8'd1 : Y+8'd2);
	assign address_first22 = index2 + (vh_i==1'b1 ? X+8'd2 : Y+8'd2);
	assign address_first23 = index2 + (vh_i==1'b1 ? X+8'd3 : Y+8'd2);
	assign address_first24 = index2 + (vh_i==1'b1 ? X+8'd4 : Y+8'd2);
	assign address_first31 = index3 + (vh_i==1'b1 ? X+8'd1 : Y+8'd3);
	assign address_first32 = index3 + (vh_i==1'b1 ? X+8'd2 : Y+8'd3);
	assign address_first33 = index3 + (vh_i==1'b1 ? X+8'd3 : Y+8'd3);
	assign address_first34 = index3 + (vh_i==1'b1 ? X+8'd4 : Y+8'd3);
	assign address_first41 = index4 + (vh_i==1'b1 ? X+8'd1 : Y+8'd4);
	assign address_first42 = index4 + (vh_i==1'b1 ? X+8'd2 : Y+8'd4);
	assign address_first43 = index4 + (vh_i==1'b1 ? X+8'd3 : Y+8'd4);
	assign address_first44 = index4 + (vh_i==1'b1 ? X+8'd4 : Y+8'd4);
	
	assign address_first11_r = index1 + (vh_i==1'b1 ? 8'd1 : 8'd1);
	assign address_first12_r = index1 + (vh_i==1'b1 ? 8'd2 : 8'd1);
	assign address_first13_r = index1 + (vh_i==1'b1 ? 8'd3 : 8'd1);
	assign address_first14_r = index1 + (vh_i==1'b1 ? 8'd4 : 8'd1);
	assign address_first21_r = index2 + (vh_i==1'b1 ? 8'd1 : 8'd2);
	assign address_first22_r = index2 + (vh_i==1'b1 ? 8'd2 : 8'd2);
	assign address_first23_r = index2 + (vh_i==1'b1 ? 8'd3 : 8'd2);
	assign address_first24_r = index2 + (vh_i==1'b1 ? 8'd4 : 8'd2);
	assign address_first31_r = index3 + (vh_i==1'b1 ? 8'd1 : 8'd3);
	assign address_first32_r = index3 + (vh_i==1'b1 ? 8'd2 : 8'd3);
	assign address_first33_r = index3 + (vh_i==1'b1 ? 8'd3 : 8'd3);
	assign address_first34_r = index3 + (vh_i==1'b1 ? 8'd4 : 8'd3);
	assign address_first41_r = index4 + (vh_i==1'b1 ? 8'd1 : 8'd4);
	assign address_first42_r = index4 + (vh_i==1'b1 ? 8'd2 : 8'd4);
	assign address_first43_r = index4 + (vh_i==1'b1 ? 8'd3 : 8'd4);
	assign address_first44_r = index4 + (vh_i==1'b1 ? 8'd4 : 8'd4);
	
	//assign address_first1_r = index1;
	//assign address_first2_r = index2;
	//assign address_first3_r = index3;
	//assign address_first4_r = index4;
	
	//second, check whether address is negetive
	reg [7:0]	address_second11a, address_second12a, address_second13a, address_second14a,
					address_second21a, address_second22a, address_second23a, address_second24a,
					address_second31a, address_second32a, address_second33a, address_second34a,
					address_second41a, address_second42a, address_second43a, address_second44a;
	//reg [7:0]	address_second1_r, address_second2_r, address_second3_r, address_second4_r;
	
	always @(vh_i or address_first11 or address_first12 or address_first13 or address_first14 or
				address_first21 or address_first22 or address_first23 or address_first24 or
				address_first31 or address_first32 or address_first33 or address_first34 or
				address_first41 or address_first42 or address_first43 or address_first44 or
				address_first11_r or address_first12_r or address_first13_r or address_first14_r or
				address_first21_r or address_first22_r or address_first23_r or address_first24_r or
				address_first31_r or address_first32_r or address_first33_r or address_first34_r or
				address_first41_r or address_first42_r or address_first43_r or address_first44_r or
				X or Y or index_aux1 or index_aux2 or index_aux3 or index_aux4)
	begin
		address_second11a = 8'd0;
		address_second12a = 8'd0;
		address_second13a = 8'd0;
		address_second14a = 8'd0;
		address_second21a = 8'd0;
		address_second22a = 8'd0;
		address_second23a = 8'd0;
		address_second24a = 8'd0;
		address_second31a = 8'd0;
		address_second32a = 8'd0;
		address_second33a = 8'd0;
		address_second34a = 8'd0;
		address_second41a = 8'd0;
		address_second42a = 8'd0;
		address_second43a = 8'd0;
		address_second44a = 8'd0;
		//address_second1_r = 8'd0;
		//address_second2_r = 8'd0;
		//address_second3_r = 8'd0;
		//address_second4_r = 8'd0;
		if(address_first11[7]==1'b1)
		begin
			//address_second11 = index_aux1 + (vh_i==1'b1 ? Y : X);
			//address11_R = index_aux1;
			address_second11a = vh_i==1'b1 ? (index_aux1+Y) : (index_aux1+X);
			address11_Ra = index_aux1;
		end
		else
		begin
			address_second11a = address_first11[7:0];
			address11_Ra = address_first11_r;
		end
		if(address_first12[7]==1'b1)
		begin
			//address_second12 = index_aux1 + (vh_i==1'b1 ? Y-8'd1 : X);
			//address12_R = index_aux1 + (vh_i==1'b1 ? 8'd1 : 8'd0);
			address_second12a = vh_i==1'b1 ? (index_aux2+Y) : (index_aux1+X+8'd1);
			address12_Ra = vh_i==1'b1 ? (index_aux2) : (index_aux1+8'd1);
		end
		else
		begin
			address_second12a = address_first12[7:0];
			address12_Ra = address_first12_r;
		end
		if(address_first13[7]==1'b1)
		begin
			//address_second13 = index_aux1 + (vh_i==1'b1 ? Y-8'd2 : X);
			//address13_R = index_aux1 + (vh_i==1'b1 ? 8'd2 : 8'd0);
			address_second13a = vh_i==1'b1 ? (index_aux3+Y) : (index_aux1+X+8'd2);
			address13_Ra = vh_i==1'b1 ? (index_aux3) : (index_aux1+8'd2);
		end
		else
		begin
			address_second13a = address_first13[7:0];
			address13_Ra = address_first13_r;
		end
		if(address_first14[7]==1'b1)
		begin
			//address_second14 = index_aux1 + (vh_i==1'b1 ? Y-8'd3 : X);
			//address14_R = index_aux1 + (vh_i==1'b1 ? 8'd3 : 8'd0);
			address_second14a = vh_i==1'b1 ? (index_aux4+Y) : (index_aux1+X+8'd3);
			address14_Ra = vh_i==1'b1 ? (index_aux4) : (index_aux1+8'd3);
		end
		else
		begin
			address_second14a = address_first14[7:0];
			address14_Ra = address_first14_r;
		end
		if(address_first21[7]==1'b1)
		begin
			//address_second21 = 8'd1 + index_aux2 + (vh_i==1'b1 ? Y : X);
			//address21_R = 8'd1 + index_aux2;
			address_second21a = vh_i==1'b1 ? (index_aux1) : (index_aux2+X);
			address21_Ra = vh_i==1'b1 ? (index_aux1) : (index_aux2); 
		end
		else
		begin
			address_second21a = address_first21[7:0];
			address21_Ra = address_first21_r;
		end
		if(address_first22[7]==1'b1)
		begin
			//address_second22 = 8'd1 + index_aux2 + (vh_i==1'b1 ? Y : X+8'd1);
			//address22_R = 8'd1 + index_aux2 + (vh_i==1'b1 ? 8'd1 : 8'd0);
			address_second22a = vh_i==1'b1 ? (index_aux2+Y+8'd1) : (index_aux2+X+8'd1);
			address22_Ra = vh_i==1'b1 ? (index_aux2+8'd1) : (index_aux2+8'd1);
		end
		else
		begin
			address_second22a = address_first22[7:0];
			address22_Ra = address_first22_r;
		end
		if(address_first23[7]==1'b1)
		begin
			//address_second23 = 8'd1 + index_aux2 + (vh_i==1'b1 ? Y : X+8'd2);
			//address23_R = 8'd1 + index_aux2 + (vh_i==1'b1 ? 8'd2 : 8'd0);
			address_second23a = vh_i==1'b1 ? (index_aux3+Y+8'd1) : (index_aux2+X+8'd2);
			address23_Ra = vh_i==1'b1 ? (index_aux3+8'd1) : (index_aux2+8'd2);
		end
		else
		begin
			address_second23a = address_first23[7:0];
			address23_Ra = address_first23_r;
		end
		if(address_first24[7]==1'b1)
		begin
			//address_second24 = 8'd1 + index_aux2 + (vh_i==1'b1 ? Y : X+8'd3);
			//address24_R = 8'd1 + index_aux2 + (vh_i==1'b1 ? 8'd3 : 8'd0);
			address_second24a = vh_i==1'b1 ? (index_aux4+Y+8'd1) : (index_aux2+X+8'd3);
			address24_Ra = vh_i==1'b1 ? (index_aux4+8'd1) : (index_aux2+8'd3);
		end
		else
		begin
			address_second24a = address_first24[7:0];
			address24_Ra = address_first24_r;
		end
		if(address_first31[7]==1'b1)
		begin
			//address_second31 = 8'd2 + index_aux3 + (vh_i==1'b1 ? Y : X+8'd2);
			//address31_R = index_aux3;
			address_second31a = vh_i==1'b1 ? (index_aux1+Y+8'd2) : (index_aux3+X);
			address31_Ra = vh_i==1'b1 ? (index_aux1+8'd2) : (index_aux3);
		end
		else
		begin
			address_second31a = address_first31[7:0];
			address31_Ra = address_first31_r;
		end
		if(address_first32[7]==1'b1)
		begin
			//address_second32 = 8'd2 + index_aux3 + (vh_i==1'b1 ? Y : X+8'd2)-8'd1;
			//address32_R = 8'd2 + index_aux3 + (vh_i==1'b1 ? 8'd1 : 8'd0)-8'd1;
			address_second32a = vh_i==1'b1 ? (index_aux2+Y+8'd2) : (index_aux3+X+8'd1);
			address32_Ra = vh_i==1'b1 ? (index_aux2+8'd2) : (index_aux3+8'd1);
		end
		else
		begin
			address_second32a = address_first32[7:0];
			address32_Ra = address_first32_r;
		end
		if(address_first33[7]==1'b1)
		begin
			//address_second33 = 8'd2 + index_aux3 + (vh_i==1'b1 ? Y : X+8'd2)-8'd2;
			//address33_R = index_aux1 + (vh_i==1'b1 ? 8'd1 : 8'd0);
			address_second33a = vh_i==1'b1 ? (index_aux3+Y+8'd2) : (index_aux3+X+8'd2);
			address33_Ra = vh_i==1'b1 ? (index_aux3+8'd2) : (index_aux3+8'd2);
		end
		else
		begin
			address_second33a = address_first33[7:0];
			address33_Ra = address_first33_r;
		end
		if(address_first34[7]==1'b1)
		begin
			//address_second34 = 8'd2 + index_aux3 + (vh_i==1'b1 ? Y : X+8'd2)-8'd3;
			//address34_R = 8'd2 + index_aux3 + (vh_i==1'b1 ? Y : X+8'd2)-8'd3;
			address_second34a = vh_i==1'b1 ? (index_aux4+Y+8'd2) : (index_aux3+X+8'd3);
			address34_Ra = vh_i==1'b1 ? (index_aux4+Y+8'd2) : (index_aux3+X+8'd3);
		end
		else
		begin
			address_second34a = address_first34[7:0];
			address34_Ra = address_first34_r;
		end
		if(address_first41[7]==1'b1)
		begin
			//address_second41 = 8'd3 + index_aux4 + (vh_i==1'b1 ? Y : X);
			//address_second4_r = index_aux4 + 8'd3;
			address_second41a = vh_i==1'b1 ? (index_aux1+Y+8'd3) : (index_aux4+X);
			address41_Ra = vh_i==1'b1 ? (index_aux1+8'd3) : (index_aux4);
		end
		else
		begin
			address_second41a = address_first41[7:0];
			address41_Ra = address_first41_r;
		end
		if(address_first42[7]==1'b1)
		begin
			//address_second42 = 8'd3 + index_aux4 + (vh_i==1'b1 ? Y : X+8'd1)-8'd1;
			address_second42a = vh_i==1'b1 ? (index_aux2+Y+8'd3) : (index_aux4+X+8'd1);
			address42_Ra = vh_i==1'b1 ? (index_aux2+8'd3) : (index_aux4+8'd1);
		end
		else
		begin
			address_second42a = address_first42[7:0];
			address42_Ra = address_first42_r;
		end
		if(address_first43[7]==1'b1)
		begin
			//address_second43 = 8'd3 + index_aux4 + (vh_i==1'b1 ? Y : X+8'd2)-8'd2;
			address_second43a = vh_i==1'b1 ? (index_aux3+Y+8'd3) : (index_aux4+X+8'd2);
			address43_Ra = vh_i==1'b1 ? (index_aux3+8'd3) : (index_aux4+8'd2);
		end
		else
		begin
			address_second43a = address_first43[7:0];
			address43_Ra = address_first43_r;
		end
		if(address_first44[7]==1'b1)
		begin
			//address_second44 = 8'd3 + index_aux4 + (vh_i==1'b1 ? Y : X+8'd3)-8'd3;
			address_second44a = vh_i==1'b1 ? (index_aux4+Y+8'd3) : (index_aux4+X+8'd3);
			address44_Ra = vh_i==1'b1 ? (index_aux4+8'd3) : (index_aux4+8'd3);
		end
		else
		begin
			address_second44a = address_first44[7:0];
			address44_Ra = address_first44_r;
		end
	end
	
	//third, get the final address
	//always @(vh_i or address_second11 or address_second12 or address_second13 or address_second14 or
				//address_second21 or address_second22 or address_second23 or address_second24 or
				//address_second31 or address_second32 or address_second33 or address_second34 or
				//address_second41 or address_second42 or address_second43 or address_second44 or
				//address_second1_r or address_second2_r or address_second3_r or address_second4_r)
	//begin
		//if(vh_i==1'b1)
		//begin
			assign address11 = address_second11a+(address_second11a==8'd255);
			assign address12 = address_second12a+(address_second12a==8'd255);
			assign address13 = address_second13a+(address_second13a==8'd255);
			assign address14 = address_second14a+(address_second14a==8'd255);
			assign address21 = address_second21a+(address_second21a==8'd255);
			assign address22 = address_second22a+(address_second22a==8'd255);
			assign address23 = address_second23a+(address_second23a==8'd255);
			assign address24 = address_second24a+(address_second24a==8'd255);
			assign address31 = address_second31a+(address_second31a==8'd255);
			assign address32 = address_second32a+(address_second32a==8'd255);
			assign address33 = address_second33a+(address_second33a==8'd255);
			assign address34 = address_second34a+(address_second34a==8'd255);
			assign address41 = address_second41a+(address_second41a==8'd255);
			assign address42 = address_second42a+(address_second42a==8'd255);
			assign address43 = address_second43a+(address_second43a==8'd255);
			assign address44 = address_second44a+(address_second44a==8'd255);	
			
			assign address11_Raa = address11_Ra+(address11_Ra==8'd255);
			assign address12_Raa = address12_Ra+(address12_Ra==8'd255);
			assign address13_Raa = address13_Ra+(address13_Ra==8'd255);
			assign address14_Raa = address14_Ra+(address14_Ra==8'd255);
			assign address21_Raa = address21_Ra+(address21_Ra==8'd255);
			assign address22_Raa = address22_Ra+(address22_Ra==8'd255);
			assign address23_Raa = address23_Ra+(address23_Ra==8'd255);
			assign address24_Raa = address24_Ra+(address24_Ra==8'd255);
			assign address31_Raa = address31_Ra+(address31_Ra==8'd255);
			assign address32_Raa = address32_Ra+(address32_Ra==8'd255);
			assign address33_Raa = address33_Ra+(address33_Ra==8'd255);
			assign address34_Raa = address34_Ra+(address34_Ra==8'd255);
			assign address41_Raa = address41_Ra+(address41_Ra==8'd255);
			assign address42_Raa = address42_Ra+(address42_Ra==8'd255);
			assign address43_Raa = address43_Ra+(address43_Ra==8'd255);
			assign address44_Raa = address44_Ra+(address44_Ra==8'd255);	
			/*address11_R = address_second1_r;
			address12_R = address_second1_r + 8'd1;
			address13_R = address_second1_r + 8'd2;
			address14_R = address_second1_r + 8'd3;
			address21_R = address_second2_r;
			address22_R = address_second2_r + 8'd1;
			address23_R = address_second2_r + 8'd2;
			address24_R = address_second2_r + 8'd3;
			address31_R = address_second3_r;
			address32_R = address_second3_r + 8'd1;
			address33_R = address_second3_r + 8'd2;
			address34_R = address_second3_r + 8'd3;
			address41_R = address_second4_r;
			address42_R = address_second4_r + 8'd1;
			address43_R = address_second4_r + 8'd2;
			address44_R = address_second4_r + 8'd3;*/	
		/*end
		else
		begin
			address11 = address_second11;
			address12 = address_second12;
			address13 = address_second13;
			address14 = address_second13;
			address21 = address_second21;
			address22 = address_second22;
			address23 = address_second23;
			address24 = address_second24;
			address31 = address_second31;
			address32 = address_second32;
			address33 = address_second33;
			address34 = address_second34;
			address41 = address_second41;
			address42 = address_second42;
			address43 = address_second43;
			address44 = address_second44;	
			/*address11_R = address_second1_r;
			address21_R = address_second1_r + 8'd1;
			address31_R = address_second1_r + 8'd2;
			address41_R = address_second1_r + 8'd3;
			address12_R = address_second2_r;
			address22_R = address_second2_r + 8'd1;
			address32_R = address_second2_r + 8'd2;
			address42_R = address_second2_r + 8'd3;
			address13_R = address_second3_r;
			address23_R = address_second3_r + 8'd1;
			address33_R = address_second3_r + 8'd2;
			address43_R = address_second3_r + 8'd3;
			address14_R = address_second4_r;
			address24_R = address_second4_r + 8'd1;
			address34_R = address_second4_r + 8'd2;
			address44_R = address_second4_r + 8'd3;*/
		///end
	//end
	/*wire [7:0] address11_Ra3,address12_Ra3,address13_Ra3,address14_Ra3,
				  address21_Ra3,address22_Ra3,address23_Ra3,address24_Ra3,
				  address31_Ra3,address32_Ra3,address33_Ra3,address34_Ra3,
				  address41_Ra3,address42_Ra3,address43_Ra3,address44_Ra3;*/
	always @(vh_i or X or Y or address41_Ra or address14_Ra or
				address11_Raa or address12_Raa or address13_Raa or address14_Raa or
				address21_Raa or address22_Raa or address23_Raa or address24_Raa or
				address31_Raa or address32_Raa or address33_Raa or address34_Raa or
				address41_Raa or address42_Raa or address43_Raa or address44_Raa)
	begin
		address11_R = 8'd0;
		address12_R = 8'd0;
		address13_R = 8'd0;
		address14_R = 8'd0;
		address21_R = 8'd0;
		address22_R = 8'd0;
		address23_R = 8'd0;
		address24_R = 8'd0;
		address31_R = 8'd0;
		address32_R = 8'd0;
		address33_R = 8'd0;
		address34_R = 8'd0;
		address41_R = 8'd0;
		address42_R = 8'd0;
		address43_R = 8'd0;
		address44_R = 8'd0;
	if(X==8'd0 && Y==8'd0)
	begin
		if(vh_i==1'b1)
		begin
			if(address41_Ra[7]==1'b1)
			begin
				address11_R = address11_Raa-address41_Raa;
				address12_R = address12_Raa-address41_Raa;
				address13_R = address13_Raa-address41_Raa;
				address14_R = address14_Raa-address41_Raa;
				address21_R = address21_Raa-address41_Raa;
				address22_R = address22_Raa-address41_Raa;
				address23_R = address23_Raa-address41_Raa;
				address24_R = address24_Raa-address41_Raa;
				address31_R = address31_Raa-address41_Raa;
				address32_R = address32_Raa-address41_Raa;
				address33_R = address33_Raa-address41_Raa;
				address34_R = address34_Raa-address41_Raa;
				address41_R = address41_Raa-address41_Raa;
				address42_R = address42_Raa-address41_Raa;
				address43_R = address43_Raa-address41_Raa;
				address44_R = address44_Raa-address41_Raa;
			end
			else
			begin
				address11_R = address11_Raa;
				address12_R = address12_Raa;
				address13_R = address13_Raa;
				address14_R = address14_Raa;
				address21_R = address21_Raa;
				address22_R = address22_Raa;
				address23_R = address23_Raa;
				address24_R = address24_Raa;
				address31_R = address31_Raa;
				address32_R = address32_Raa;
				address33_R = address33_Raa;
				address34_R = address34_Raa;
				address41_R = address41_Raa;
				address42_R = address42_Raa;
				address43_R = address43_Raa;
				address44_R = address44_Raa;
			end
		end
		else
		begin
			if(address14_Ra[7]==1'b1)
			begin
				address11_R = address11_Raa-address14_Raa;
				address12_R = address12_Raa-address14_Raa;
				address13_R = address13_Raa-address14_Raa;
				address14_R = address14_Raa-address14_Raa;
				address21_R = address21_Raa-address14_Raa;
				address22_R = address22_Raa-address14_Raa;
				address23_R = address23_Raa-address14_Raa;
				address24_R = address24_Raa-address14_Raa;
				address31_R = address31_Raa-address14_Raa;
				address32_R = address32_Raa-address14_Raa;
				address33_R = address33_Raa-address14_Raa;
				address34_R = address34_Raa-address14_Raa;
				address41_R = address41_Raa-address14_Raa;
				address42_R = address42_Raa-address14_Raa;
				address43_R = address43_Raa-address14_Raa;
				address44_R = address44_Raa-address14_Raa;
			end
			else
			begin
				address11_R = address11_Raa;
				address12_R = address12_Raa;
				address13_R = address13_Raa;
				address14_R = address14_Raa;
				address21_R = address21_Raa;
				address22_R = address22_Raa;
				address23_R = address23_Raa;
				address24_R = address24_Raa;
				address31_R = address31_Raa;
				address32_R = address32_Raa;
				address33_R = address33_Raa;
				address34_R = address34_Raa;
				address41_R = address41_Raa;
				address42_R = address42_Raa;
				address43_R = address43_Raa;
				address44_R = address44_Raa;
			end			
		end
	end
	end
	
	//four, top_or_left for address11 and address44
	assign top_or_left11 = vh_i;
	assign top_or_left12 = (vh_i==1'b1 && address_first12[7]==1'b0) || (vh_i==1'b0 && address_first12[7]==1'b1);
	assign top_or_left13 = (vh_i==1'b1 && address_first13[7]==1'b0) || (vh_i==1'b0 && address_first13[7]==1'b1);
	assign top_or_left14 = (vh_i==1'b1 && address_first14[7]==1'b0) || (vh_i==1'b0 && address_first14[7]==1'b1);
	
	assign top_or_left21 = (vh_i==1'b1 && address_first21[7]==1'b0) || (vh_i==1'b0 && address_first21[7]==1'b1);
	assign top_or_left22 = (vh_i==1'b1 && address_first22[7]==1'b0) || (vh_i==1'b0 && address_first22[7]==1'b1);
	assign top_or_left23 = (vh_i==1'b1 && address_first23[7]==1'b0) || (vh_i==1'b0 && address_first23[7]==1'b1);
	assign top_or_left24 = (vh_i==1'b1 && address_first24[7]==1'b0) || (vh_i==1'b0 && address_first24[7]==1'b1);
	
	assign top_or_left31 = (vh_i==1'b1 && address_first31[7]==1'b0) || (vh_i==1'b0 && address_first31[7]==1'b1);
	assign top_or_left32 = (vh_i==1'b1 && address_first32[7]==1'b0) || (vh_i==1'b0 && address_first32[7]==1'b1);
	assign top_or_left33 = (vh_i==1'b1 && address_first33[7]==1'b0) || (vh_i==1'b0 && address_first33[7]==1'b1);
	assign top_or_left34 = (vh_i==1'b1 && address_first34[7]==1'b0) || (vh_i==1'b0 && address_first34[7]==1'b1);
	
	assign top_or_left41 = (vh_i==1'b1 && address_first41[7]==1'b0) || (vh_i==1'b0 && address_first41[7]==1'b1);
	assign top_or_left42 = (vh_i==1'b1 && address_first42[7]==1'b0) || (vh_i==1'b0 && address_first42[7]==1'b1);
	assign top_or_left43 = (vh_i==1'b1 && address_first43[7]==1'b0) || (vh_i==1'b0 && address_first43[7]==1'b1);
	assign top_or_left44 = (vh_i==1'b1 && address_first44[7]==1'b0) || (vh_i==1'b0 && address_first44[7]==1'b1);
	
	assign negetive_flag = (~top_or_left14 && top_or_left41) && (top_or_left14 && ~top_or_left41);

endmodule	