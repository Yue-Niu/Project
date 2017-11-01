// 这个模块主要是选择角度预测生成的address或者Planar预测生成的地址
module address_to_RAM
(
	input	[7:0]	address_RAM_angle,
	input [7:0]	address_RAM_planar,
	input [7:0]	address_RAM_DC,
	
	input 		en_top_angle,
	input 		en_left_angle,
	input    	en_top_planar,
	input			en_left_planar,
	input 		en_top_DC,
	input			en_left_DC,
	
	input			angle_or_planar,
	input			DC_flag,
	
	output reg[7:0]	address_RAM,
	output reg		en_top,
	output reg		en_left
);
	
	always @(angle_or_planar or DC_flag or
				address_RAM_angle or address_RAM_planar or address_RAM_DC or
				en_top_angle or en_top_planar or en_left_angle or en_left_planar or en_top_DC or en_left_DC)
	begin
		if(DC_flag==1'b1)
		begin
			address_RAM <= address_RAM_DC;
			en_top <= en_top_DC;
			en_left <= en_left_DC;
		end
		else
		begin
			if(angle_or_planar==1'b1)
			begin
				address_RAM <= address_RAM_angle;
				en_top <= en_top_angle;
				en_left <= en_left_angle;
			end
			else
			begin
				address_RAM <= address_RAM_planar;
				en_top <= en_top_planar;
				en_left <= en_left_planar;
			end
		end
	end
	
endmodule
