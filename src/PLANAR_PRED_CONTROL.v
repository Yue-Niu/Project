//PLANAR预测的控制状态机
module PLANAR_PRED_CONTROL
(
	input CLK1,
	input RST_n,
	
	input [2:0]	PU,
	
	output reg[7:0] TOP_RIGHT,
	output reg[7:0] BOTTOM_LEFT,
	
	output reg DCVAL_flag,
	output reg LEFT_VALID,
	output reg TOP_VALID
);

	/*
	状态机总共有256个工作状态，分别对应不同的基本预测块，
	另外还有一个闲置状态
*/
	parameter idle = 9'd0,
				 S1 = 9'd1, S2 = 9'd2, S3 = 9'd3, S4 = 9'd4, S5 = 9'd5, S6 = 9'd6, S7 = 9'd7, S8 = 9'd8,
				 S9 = 9'd9, S10 = 9'd10, S11 = 9'd11, S12 = 9'd12, S13 = 9'd13, S14 = 9'd14, S15 = 9'd15, S16 = 9'd16,
				 S17 = 9'd17, S18 = 9'd18, S19 = 9'd19, S20 = 9'd20, S21 = 9'd21, S22 = 9'd22, S23 = 9'd23, S24 = 9'd24,
				 S25 = 9'd25, S26 = 9'd26, S27 = 9'd27, S28 = 9'd28, S29 = 9'd29, S30 = 9'd30, S31 = 9'd31, S32 = 9'd32,
				 S33 = 9'd33, S34 = 9'd34, S35 = 9'd35, S36 = 9'd36, S37 = 9'd37, S38 = 9'd38, S39 = 9'd39, S40 = 9'd40,
				 S41 = 9'd41, S42 = 9'd42, S43 = 9'd43, S44 = 9'd44, S45 = 9'd45, S46 = 9'd46, S47 = 9'd47, S48 = 9'd48,
				 S49 = 9'd49, S50 = 9'd50, S51 = 9'd51, S52 = 9'd52, S53 = 9'd53, S54 = 9'd54, S55 = 9'd55, S56 = 9'd56,
				 S57 = 9'd57, S58 = 9'd58, S59 = 9'd59, S60 = 9'd60, S61 = 9'd61, S62 = 9'd62, S63 = 9'd63, S64 = 9'd64,
				 S65 = 9'd65, S66 = 9'd66, S67 = 9'd67, S68 = 9'd68, S69 = 9'd69, S70 = 9'd70, S71 = 9'd71, S72 = 9'd72,
				 S73 = 9'd73, S74 = 9'd74, S75 = 9'd75, S76 = 9'd76, S77 = 9'd77, S78 = 9'd78, S79 = 9'd79, S80 = 9'd80,
				 S81 = 9'd81, S82 = 9'd82, S83 = 9'd83, S84 = 9'd84, S85 = 9'd85, S86 = 9'd86, S87 = 9'd87, S88 = 9'd88,
				 S89 = 9'd89, S90 = 9'd90, S91 = 9'd91, S92 = 9'd92, S93 = 9'd93, S94 = 9'd94, S95 = 9'd95, S96 = 9'd96,
				 S97 = 9'd97, S98 = 9'd98, S99 = 9'd99, S100 = 9'd100, S101 = 9'd101, S102 = 9'd102, S103 = 9'd103, S104 = 9'd104,
				 S105 = 9'd105, S106 = 9'd106, S107 = 9'd107, S108 = 9'd108, S109 = 9'd109, S110 = 9'd110, S111 = 9'd111, S112 = 9'd112,
				 S113 = 9'd113, S114 = 9'd114, S115 = 9'd115, S116 = 9'd116, S117 = 9'd117, S118 = 9'd118, S119 = 9'd119, S120 = 9'd120,
				 S121 = 9'd121, S122 = 9'd122, S123 = 9'd123, S124 = 9'd124, S125 = 9'd125, S126 = 9'd126, S127 = 9'd127, S128 = 9'd128,
				 S129 = 9'd129, S130 = 9'd130, S131 = 9'd131, S132 = 9'd132, S133 = 9'd133, S134 = 9'd134, S135 = 9'd135, S136 = 9'd136,
				 S137 = 9'd137, S138 = 9'd138, S139 = 9'd139, S140 = 9'd140, S141 = 9'd141, S142 = 9'd142, S143 = 9'd143, S144 = 9'd144,
				 S145 = 9'd145, S146 = 9'd146, S147 = 9'd147, S148 = 9'd148, S149 = 9'd149, S150 = 9'd150, S151 = 9'd151, S152 = 9'd152,
				 S153 = 9'd153, S154 = 9'd154, S155 = 9'd155, S156 = 9'd156, S157 = 9'd157, S158 = 9'd158, S159 = 9'd159, S160 = 9'd160,
				 S161 = 9'd161, S162 = 9'd162, S163 = 9'd163, S164 = 9'd164, S165 = 9'd165, S166 = 9'd166, S167 = 9'd167, S168 = 9'd168,
				 S169 = 9'd169, S170 = 9'd170, S171 = 9'd171, S172 = 9'd172, S173 = 9'd173, S174 = 9'd174, S175 = 9'd175, S176 = 9'd176,
				 S177 = 9'd177, S178 = 9'd178, S179 = 9'd179, S180 = 9'd180, S181 = 9'd181, S182 = 9'd182, S183 = 9'd183, S184 = 9'd184,
				 S185 = 9'd185, S186 = 9'd186, S187 = 9'd187, S188 = 9'd188, S189 = 9'd189, S190 = 9'd190, S191 = 9'd191, S192 = 9'd192,
				 S193 = 9'd193, S194 = 9'd194, S195 = 9'd195, S196 = 9'd196, S197 = 9'd197, S198 = 9'd198, S199 = 9'd199, S200 = 9'd200,
				 S201 = 9'd201, S202 = 9'd202, S203 = 9'd203, S204 = 9'd204, S205 = 9'd205, S206 = 9'd206, S207 = 9'd207, S208 = 9'd208,
				 S209 = 9'd209, S210 = 9'd210, S211 = 9'd211, S212 = 9'd212, S213 = 9'd213, S214 = 9'd214, S215 = 9'd215, S216 = 9'd216,
				 S217 = 9'd217, S218 = 9'd218, S219 = 9'd219, S220 = 9'd220, S221 = 9'd221, S222 = 9'd222, S223 = 9'd223, S224 = 9'd224,
				 S225 = 9'd225, S226 = 9'd226, S227 = 9'd227, S228 = 9'd228, S229 = 9'd229, S230 = 9'd230, S231 = 9'd231, S232 = 9'd232,
				 S233 = 9'd233, S234 = 9'd234, S235 = 9'd235, S236 = 9'd236, S237 = 9'd237, S238 = 9'd238, S239 = 9'd239, S240 = 9'd240,
				 S241 = 9'd241, S242 = 9'd242, S243 = 9'd243, S244 = 9'd244, S245 = 9'd245, S246 = 9'd246, S247 = 9'd247, S248 = 9'd248,
				 S249 = 9'd249, S250 = 9'd250, S251 = 9'd251, S252 = 9'd252, S253 = 9'd253, S254 = 9'd254, S255 = 9'd255, S256 = 9'd256;
				 
	reg [8:0]	CS,NS;
	always @(posedge CLK1 or negedge RST_n)
	begin
		if(RST_n==1'b0)
			CS <= idle;
		else
			CS <= NS;
	end
	
	always @(CS or PU)
	begin
		NS <= idle;
		case(CS)
			idle:
				NS <= S1;
			S1:
				NS <= S2;
			S2:
			begin
				if(PU==3'd1)
					NS <= S17;
				else
					NS <= S3;
			end
			S3:
				NS <= S4;
			S4:
			begin
				if(PU==3'd1)
					NS <= S19;
				else if(PU==3'd2)
					NS <= S17;
				else
					NS <= S5;
			end
			S5:
				NS <= S6;
			S6:
			begin
				if(PU==3'd1)
					NS <= S21;
				else
					NS <= S7;
			end
			S7:
				NS <= S8;
			S8:
			begin
				if(PU==3'd1)
					NS <= S23;
				else if(PU==3'd2)
					NS <= S21;
				else if(PU==3'd3)
					NS <= S17;
				else
					NS <= S9;
			end
			S9:
				NS <= S10;
			S10:
			begin
				if(PU==3'd1)
					NS <= S25;
				else
					NS <= S11;
			end
			S11:
				NS <= S12;
			S12:
			begin
				if(PU==3'd1)
					NS <= S27;
				else if(PU==3'd2)
					NS <= S25;
				else
					NS <= S13;
			end
			S13:
				NS <= S14;
			S14:
			begin
				if(PU==3'd1)
					NS <= S29;
				else
					NS <= S15;
			end
			S15:
				NS <= S16;
			S16:
			begin
				if(PU==3'd1)
					NS <= S31;
				else if(PU==3'd2)
					NS <= S29;
				else if(PU==3'd3)
					NS <= S25;
				else
					NS <= S17;
			end
			S17:
				NS <= S18;
			S18:
			begin
				if(PU==3'd1)
					NS <= S3;
				else
					NS <= S19;
			end
			S19:
				NS <= S20;
			S20:
			begin
				if(PU==3'd1)
					NS <= S5;
				else if(PU==3'd2)
					NS <= S33;
				else
					NS <= S21;
			end
			S21:
				NS <= S22;
			S22:
			begin
				if(PU==3'd1)
					NS <= S7;
				else
					NS <= S23;
			end
			S23:
				NS <= S24;
			S24:
			begin
				if(PU==3'd1)
					NS <= S9;
				else if(PU==3'd2)
					NS <= S37;
				else if(PU==3'd3)
					NS <= S33;
				else
					NS <= S25;
			end
			S25:
				NS <= S26;
			S26:
			begin
				if(PU==3'd1)
					NS <= S11;
				else
					NS <= S17;
			end
			S27:
				NS <= S28;
			S28:
			begin
				if(PU==3'd1)
					NS <= S13;
				else if(PU==3'd2)
					NS <= S41;
				else
					NS <= S29;
			end
			S29:
				NS <= S30;
			S30:
			begin
				if(PU==3'd1)
					NS <= S15;
				else
					NS <= S31;
			end
			S31:
				NS <= S32;
			S32:
			begin
				if(PU==3'd2)
					NS <= S45;
				else if(PU==3'd3)
					NS <= S41;
				else
					NS <= S33;
			end
			S33:
				NS <= S34;
			S34:
			begin
				if(PU==3'd1)
					NS <= S49;
				else
					NS <= S35;
			end
			S35:
				NS <= S36;
			S36:
			begin
				if(PU==3'd1)
					NS <= S51;
				else if(PU==3'd2)
					NS <= S49;
				else
					NS <= S37;
			end
			S37:
				NS <= S38;
			S38:
			begin
				if(PU==3'd1)
					NS <= S53;
				else
					NS <= S39;
			end
			S39:
				NS <= S40;
			S40:
			begin
				if(PU==3'd1)
					NS <= S55;
				else if(PU==3'd2)
					NS <= S53;
				else if(PU==3'd3)
					NS <= S49;
				else
					NS <= S41;
			end
			S41:
				NS <= S42;
			S42:
			begin
				if(PU==3'd1)
					NS <= S57;
				else
					NS <= S43;
			end
			S43:
				NS <= S44;
			S44:
			begin
				if(PU==3'd1)
					NS <= S59;
				else if(PU==3'd2)
					NS <= S57;
				else
					NS <= S45;
			end
			S45:
				NS <= S46;
			S46:
			begin
				if(PU==3'd1)
					NS <= S61;
				else
					NS <= S47;
			end
			S47:
				NS <= S48;
			S48:
			begin
				if(PU==3'd1)
					NS <= S63;
				else if(PU==3'd2)
					NS <= S61;
				else if(PU==3'd3)
					NS <= S57;
				else
					NS <= S49;
			end
			S49:
				NS <= S50;
			S50:
			begin
				if(PU==3'd1)
					NS <= S35;
				else
					NS <= S51;
			end
			S51:
				NS <= S52;
			S52:
			begin
				if(PU==3'd1)
					NS <= S37;
				else if(PU==3'd2)
					NS <= S5;
				else
					NS <= S53;
			end
			S53:
				NS <= S54;
			S54:
			begin
				if(PU==3'd1)
					NS <= S39;
				else
					NS <= S55;
			end
			S55:
				NS <= S56;
			S56:
			begin
				if(PU==3'd1)
					NS <= S41;
				else if(PU==3'd2)
					NS <= S9;
				else if(PU==3'd3)
					NS <= S65;
				else
					NS <= S57;
			end
			S57:
				NS <= S58;
			S58:
			begin
				if(PU==3'd1)
					NS <= S43;
				else
					NS <= S59;
			end
			S59:
				NS <= S60;
			S60:
			begin
				if(PU==3'd1)
					NS <= S45;
				else if(PU==3'd2)
					NS <= S13;
				else
					NS <= S61;
			end
			S61:
				NS <= S62;
			S62:
			begin
				if(PU==3'd1)
					NS <= S47;
				else
					NS <= S63;
			end
			S63:
				NS <= S64;
			S64:
			begin
				if(PU==3'd3)
					NS <= S73;
				else
					NS <= S65;
			end
			S65:
				NS <= S66;
			S66:
			begin
				if(PU==3'd1)
					NS <= S81;
				else
					NS <= S67;
			end
			S67:
				NS <= S68;
			S68:
			begin
				if(PU==3'd1)
					NS <= S83;
				else if(PU==3'd2)
					NS <= S81;
				else
					NS <= S69;
			end
			S69:
				NS <= S70;
			S70:
			begin
				if(PU==3'd1)
					NS <= S85;
				else
					NS <= S71;
			end
			S71:
				NS <= S72;
			S72:
			begin
				if(PU==3'd1)
					NS <= S87;
				else if(PU==3'd2)
					NS <= S85;
				else if(PU==3'd3)
					NS <= S81;
				else
					NS <= S73;
			end
			S73:
				NS <= S74;
			S74:
			begin
				if(PU==3'd1)
					NS <= S89;
				else
					NS <= S75;
			end
			S75:
				NS <= S76;
			S76:
			begin
				if(PU==3'd1)
					NS <= S91;
				else if(PU==3'd2)
					NS <= S89;
				else
					NS <= S77;
			end
			S77:
				NS <= S78;
			S78:
			begin
				if(PU==3'd1)
					NS <= S93;
				else
					NS <= S79;
			end
			S79:
				NS <= S80;
			S80:
			begin
				if(PU==3'd1)
					NS <= S95;
				else if(PU==3'd2)
					NS <= S93;
				else if(PU==3'd3)
					NS <= S89;
				else
					NS <= S81;
			end
			S81:
				NS <= S82;
			S82:
			begin
				if(PU==3'd1)
					NS <= S67;
				else
					NS <= S83;
			end
			S83:
				NS <= S84;
			S84:
			begin
				if(PU==3'd1)
					NS <= S69;
				else if(PU==3'd2)
					NS <= S97;
				else
					NS <= S85;
			end
			S85:
				NS <= S86;
			S86:
			begin
				if(PU==3'd1)
					NS <= S71;
				else
					NS <= S87;
			end
			S87:
				NS <= S88;
			S88:
			begin
				if(PU==3'd1)
					NS <= S73;
				else if(PU==3'd2)
					NS <= S101;
				else if(PU==3'd3)
					NS <= S97;
				else
					NS <= S89;
			end
			S89:
				NS <= S90;
			S90:
			begin
				if(PU==3'd1)
					NS <= S75;
				else
					NS <= S91;
			end
			S91:
				NS <= S92;
			S92:
			begin
				if(PU==3'd1)
					NS <= S77;
				else if(PU==3'd2)
					NS <= S105;
				else
					NS <= S93;
			end
			S93:
				NS <= S94;
			S94:
			begin
				if(PU==3'd1)
					NS <= S79;
				else
					NS <= S95;
			end
			S95:
				NS <= S96;
			S96:
			begin
				if(PU==3'd2)
					NS <= S109;
				else if(PU==3'd3)
					NS <= S105;
				else
					NS <= S97;
			end
			S97:
				NS <= S98;
			S98:
			begin
				if(PU==3'd1)
					NS <= S113;
				else
					NS <= S99;
			end
			S99:
				NS <= S100;
			S100:
			begin
				if(PU==3'd1)
					NS <= S115;
				else if(PU==3'd2)
					NS <= S113;
				else
					NS <= S101;
			end
			S101:
				NS <= S102;
			S102:
			begin
				if(PU==3'd1)
					NS <= S117;
				else
					NS <= S103;
			end
			S103:
				NS <= S104;
			S104:
			begin
				if(PU==3'd1)
					NS <= S119;
				else if(PU==3'd2)
					NS <= S117;
				else if(PU==3'd3)
					NS <= S113;
				else
					NS <= S105;
			end
			S105:
				NS <= S106;
			S106:
			begin
				if(PU==3'd1)
					NS <= S121;
				else
					NS <= S107;
			end
			S107:
				NS <= S108;
			S108:
			begin
				if(PU==3'd1)
					NS <= S123;
				else if(PU==3'd2)
					NS <= S121;
				else
					NS <= S109;
			end
			S109:
				NS <= S110;
			S110:
			begin
				if(PU==3'd1)
					NS <= S125;
				else
					NS <= S111;
			end
			S111:
				NS <= S112;
			S112:
			begin
				if(PU==3'd1)
					NS <= S127;
				else if(PU==3'd2)
					NS <= S125;
				else if(PU==3'd3)
					NS <= S121;
				else
					NS <= S113;
			end
			S113:
				NS <= S114;
			S114:
			begin
				if(PU==3'd1)
					NS <= S99;
				else
					NS <= S115;
			end
			S115:
				NS <= S116;
			S116:
			begin
				if(PU==3'd1)
					NS <= S101;
				else if(PU==3'd2)
					NS <= S69;
				else
					NS <= S117;
			end
			S117:
				NS <= S118;
			S118:
			begin
				if(PU==3'd1)
					NS <= S103;
				else
					NS <= S119;
			end
			S119:
				NS <= S120;
			S120:
			begin
				if(PU==3'd1)
					NS <= S105;
				else if(PU==3'd2)
					NS <= S73;
				else if(PU==3'd3)
					NS <= S9;
				else
					NS <= S121;
			end
			S121:
				NS <= S122;
			S122:
			begin
				if(PU==3'd1)
					NS <= S107;
				else
					NS <= S123;
			end
			S123:
				NS <= S124;
			S124:
			begin
				if(PU==3'd1)
					NS <= S109;
				else if(PU==3'd2)
					NS <= S77;
				else
					NS <= S125;
			end
			S125:
				NS <= S126;
			S126:
			begin
				if(PU==3'd1)
					NS <= S111;
				else
					NS <= S127;
			end
			S127:
				NS <= S128;
			S128:
				NS <= S129;
			S129:
				NS <= S130;
			S130:
			begin
				if(PU==3'd1)
					NS <= S145;
				else
					NS <= S31;
			end
			S131:
				NS <= S132;
			S132:
			begin
				if(PU==3'd1)
					NS <= S147;
				else if(PU==3'd2)
					NS <= S145;
				else
					NS <= S133;
			end
			S133:
				NS <= S134;
			S134:
			begin
				if(PU==3'd1)
					NS <= S149;
				else
					NS <= S135;
			end
			S135:
				NS <= S136;
			S136:
			begin
				if(PU==3'd1)
					NS <= S151;
				else if(PU==3'd2)
					NS <= S149;
				else if(PU==3'd3)
					NS <= S145;
				else
					NS <= S137;
			end
			S137:
				NS <= S138;
			S138:
			begin
				if(PU==3'd1)
					NS <= S153;
				else
					NS <= S139;
			end
			S139:
				NS <= S140;
			S140:
			begin
				if(PU==3'd1)
					NS <= S155;
				else if(PU==3'd2)
					NS <= S153;
				else
					NS <= S141;
			end
			S141:
				NS <= S142;
			S142:
			begin
				if(PU==3'd1)
					NS <= S157;
				else
					NS <= S143;
			end
			S143:
				NS <= S144;
			S144:
			begin
				if(PU==3'd1)
					NS <= S159;
				else if(PU==3'd2)
					NS <= S157;
				else if(PU==3'd3)
					NS <= S153;
				else
					NS <= S145;
			end
			S145:
				NS <= S146;
			S146:
			begin
				if(PU==3'd1)
					NS <= S131;
				else
					NS <= S147;
			end
			S147:
				NS <= S148;
			S148:
			begin
				if(PU==3'd1)
					NS <= S133;
				else if(PU==3'd2)
					NS <= S161;
				else
					NS <= S149;
			end
			S149:
				NS <= S150;
			S150:
			begin
				if(PU==3'd1)
					NS <= S135;
				else
					NS <= S151;
			end
			S151:
				NS <= S152;
			S152:
			begin
				if(PU==3'd1)
					NS <= S137;
				else if(PU==3'd2)
					NS <= S165;
				else if(PU==3'd3)
					NS <= S161;
				else
					NS <= S153;
			end
			S153:
				NS <= S154;
			S154:
			begin
				if(PU==3'd1)
					NS <= S139;
				else
					NS <= S155;
			end
			S155:
				NS <= S156;
			S156:
			begin
				if(PU==3'd1)
					NS <= S141;
				else if(PU==3'd2)
					NS <= S169;
				else
					NS <= S157;
			end
			S157:
				NS <= S158;
			S158:
			begin
				if(PU==3'd1)
					NS <= S143;
				else
					NS <= S159;
			end
			S159:
				NS <= S160;
			S160:
			begin
				if(PU==3'd2)
					NS <= S173;
				else if(PU==3'd3)
					NS <= S169;
				else
					NS <= S161;
			end
			S161:
				NS <= S162;
			S162:
			begin
				if(PU==3'd1)
					NS <= S177;
				else
					NS <= S163;
			end
			S163:
				NS <= S164;
			S164:
			begin
				if(PU==3'd1)
					NS <= S179;
				else if(PU==3'd2)
					NS <= S177;
				else
					NS <= S165;
			end
			S165:
				NS <= S166;
			S166:
			begin
				if(PU==3'd1)
					NS <= S181;
				else
					NS <= S167;
			end
			S167:
				NS <= S168;
			S168:
			begin
				if(PU==3'd1)
					NS <= S183;
				else if(PU==3'd2)
					NS <= S181;
				else if(PU==3'd3)
					NS <= S177;
				else
					NS <= S169;
			end
			S169:
				NS <= S170;
			S170:
			begin
				if(PU==3'd1)
					NS <= S185;
				else
					NS <= S171;
			end
			S171:
				NS <= S172;
			S172:
			begin
				if(PU==3'd1)
					NS <= S187;
				else if(PU==3'd2)
					NS <= S185;
				else
					NS <= S173;
			end
			S173:
				NS <= S174;
			S174:
			begin
				if(PU==3'd1)
					NS <= S189;
				else
					NS <= S175;
			end
			S175:
				NS <= S176;
			S176:
			begin
				if(PU==3'd1)
					NS <= S191;
				if(PU==3'd2)
					NS <= S189;
				else if(PU==3'd3)
					NS <= S185;
				else
					NS <= S177;
			end
			S177:
				NS <= S178;
			S178:
			begin
				if(PU==3'd1)
					NS <= S163;
				else
					NS <= S179;
			end
			S179:
				NS <= S180;
			S180:
			begin
				if(PU==3'd1)
					NS <= S165;
				else if(PU==3'd2)
					NS <= S133;
				else
					NS <= S181;
			end
			S181:
				NS <= S182;
			S182:
			begin
				if(PU==3'd1)
					NS <= S167;
				else
					NS <= S183;
			end
			S183:
				NS <= S184;
			S184:
			begin
				if(PU==3'd1)
					NS <= S169;
				else if(PU==3'd2)
					NS <= S137;
				else if(PU==3'd3)
					NS <= S193;
				else
					NS <= S185;
			end
			S185:
				NS <= S186;
			S186:
			begin
				if(PU==3'd1)
					NS <= S171;
				else
					NS <= S187;
			end
			S187:
				NS <= S188;
			S188:
			begin
				if(PU==3'd1)
					NS <= S173;
				else if(PU==3'd2)
					NS <= S141;
				else
					NS <= S189;
			end
			S189:
				NS <= S190;
			S190:
			begin
				if(PU==3'd1)
					NS <= S127;
				else
					NS <= S191;
			end
			S191:
				NS <= S192;
			S192:
			begin
				if(PU==3'd3)
					NS <= S201;
				else
					NS <= S193;
			end
			S193:
				NS <= S194;
			S194:
			begin
				if(PU==3'd1)
					NS <= S209;
				else
					NS <= S195;
			end
			S195:
				NS <= S196;
			S196:
			begin
				if(PU==3'd1)
					NS <= S211;
				else if(PU==3'd2)
					NS <= S209;
				else
					NS <= S197;
			end
			S197:
				NS <= S198;
			S198:
			begin
				if(PU==3'd1)
					NS <= S213;
				else
					NS <= S199;
			end
			S199:
				NS <= S200;
			S200:
			begin
				if(PU==3'd1)
					NS <= S215;
				else if(PU==3'd2)
					NS <= S213;
				else if(PU==3'd3)
					NS <= S209;
				else
					NS <= S201;
			end
			S201:
				NS <= S202;
			S202:
			begin
				if(PU==3'd1)
					NS <= S217;
				else
					NS <= S203;
			end
			S203:
				NS <= S204;
			S204:
			begin
				if(PU==3'd1)
					NS <= S219;
				else if(PU==3'd2)
					NS <= S217;
				else
					NS <= S205;
			end
			S205:
				NS <= S206;
			S206:
			begin
				if(PU==3'd1)
					NS <= S221;
				else
					NS <= S207;
			end
			S207:
				NS <= S208;
			S208:
			begin
				if(PU==3'd1)
					NS <= S223;
				else if(PU==3'd2)
					NS <= S221;
				else if(PU==3'd3)
					NS <= S217;
				else
					NS <= S209;
			end
			S209:
				NS <= S210;
			S210:
			begin
				if(PU==3'd1)
					NS <= S195;
				else
					NS <= S211;
			end
			S211:
				NS <= S212;
			S212:
			begin
				if(PU==3'd1)
					NS <= S197;
				else if(PU==3'd2)
					NS <= S225;
				else
					NS <= S213;
			end
			S213:
				NS <= S214;
			S214:
			begin
				if(PU==3'd1)
					NS <= S199;
				else
					NS <= S215;
			end
			S215:
				NS <= S216;
			S216:
			begin
				if(PU==3'd1)
					NS <= S201;
				else if(PU==3'd2)
					NS <= S229;
				else if(PU==3'd3)
					NS <= S225;
				else
					NS <= S217;
			end
			S217:
				NS <= S218;
			S218:
			begin
				if(PU==3'd1)
					NS <= S203;
				else
					NS <= S219;
			end
			S219:
				NS <= S220;
			S220:
			begin
				if(PU==3'd1)
					NS <= S205;
				else if(PU==3'd2)
					NS <= S233;
				else
					NS <= S221;
			end
			S221:
				NS <= S222;
			S222:
			begin
				if(PU==3'd1)
					NS <= S207;
				else
					NS <= S223;
			end
			S223:
				NS <= S224;
			S224:
			begin
				if(PU==3'd2)
					NS <= S237;
				else if(PU==3'd3)
					NS <= S233;
				else
					NS <= S225;
			end
			S225:
				NS <= S226;
			S226:
			begin
				if(PU==3'd1)
					NS <= S241;
				else
					NS <= S227;
			end
			S227:
				NS <= S228;
			S228:
			begin
				if(PU==3'd1)
					NS <= S243;
				else if(PU==3'd2)
					NS <= S241;
				else
					NS <= S229;
			end
			S229:
				NS <= S230;
			S230:
			begin
				if(PU==3'd1)
					NS <= S245;
				else
					NS <= S231;
			end
			S231:
				NS <= S232;
			S232:
			begin
				if(PU==3'd1)
					NS <= S247;
				else if(PU==3'd2)
					NS <= S245;
				else if(PU==3'd3)
					NS <= S241;
				else
					NS <= S233;
			end
			S233:
				NS <= S234;
			S234:
			begin
				if(PU==3'd1)
					NS <= S249;
				else
					NS <= S235;
			end
			S235:
				NS <= S236;
			S236:
			begin
				if(PU==3'd1)
					NS <= S251;
				else if(PU==3'd2)
					NS <= S149;
				else
					NS <= S237;
			end
			S237:
				NS <= S238;
			S238:
			begin
				if(PU==3'd1)
					NS <= S253;
				else
					NS <= S239;
			end
			S239:
				NS <= S240;
			S240:
			begin
				if(PU==3'd1)
					NS <= S255;
				if(PU==3'd2)
					NS <= S253;
				else if(PU==3'd3)
					NS <= S249;
				else
					NS <= S241;
			end
			S241:
				NS <= S242;
			S242:
			begin
				if(PU==3'd1)
					NS <= S227;
				else
					NS <= S243;
			end
			S243:
				NS <= S244;
			S244:
			begin
				if(PU==3'd1)
					NS <= S229;
				else if(PU==3'd2)
					NS <= S197;
				else
					NS <= S245;
			end
			S245:
				NS <= S246;
			S246:
			begin
				if(PU==3'd1)
					NS <= S231;
				else
					NS <= S247;
			end
			S247:
				NS <= S248;
			S248:
			begin
				if(PU==3'd1)
					NS <= S233;
				else if(PU==3'd2)
					NS <= S201;
				else if(PU==3'd3)
					NS <= S137;
				else
					NS <= S249;
			end
			S249:
				NS <= S250;
			S250:
			begin
				if(PU==3'd1)
					NS <= S235;
				else
					NS <= S251;
			end
			S251:
				NS <= S252;
			S252:
			begin
				if(PU==3'd1)
					NS <= S237;
				else if(PU==3'd2)
					NS <= S205;
				else
					NS <= S253;
			end
			S253:
				NS <= S254;
			S254:
			begin
				if(PU==3'd1)
					NS <= S239;
				else
					NS <= S255;
			end
			S255:
				NS <= S256;
			S256:
				NS <= idle;
			default:
				NS <= idle;
		endcase
	end
	
	always @(CS or PU)
	begin
		case(CS)
			idle:
			begin
				TOP_RIGHT <= 8'd0;
				BOTTOM_LEFT <= 8'd0;
				DCVAL_flag <= 1'b0;
				LEFT_VALID <= 1'b0;
				TOP_VALID <= 1'b0;
			end
			S1:
			begin
				LEFT_VALID <= 1'b1;
				TOP_VALID <= 1'b1;
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
					end
				endcase
			end
			S2:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S3:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S4:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S5:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S6:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S7:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S8:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S9:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S10:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S11:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S12:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S13:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S14:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S15:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S16:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd4;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S17:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S18:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S19:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S20:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S21:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S22:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S23:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S24:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S25:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S26:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S27:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S28:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S29:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S30:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S31:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S32:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd8;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S33:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S34:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S35:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S36:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S37:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S38:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S39:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S40:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S41:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S42:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S43:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S44:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S45:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S46:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S47:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S48:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd12;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S49:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S50:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S51:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S52:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
				endcase
			end
			S53:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S54:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S55:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S56:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S57:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S58:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S59:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S60:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S61:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S62:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S63:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S64:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd16;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S65:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S66:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S67:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S68:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S69:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S70:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S71:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S72:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S73:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S74:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S75:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S76:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S77:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S78:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S79:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S80:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd20;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S81:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S82:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S83:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S84:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S85:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S86:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S87:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S88:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S89:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S90:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S91:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S92:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S93:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S94:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S95:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S96:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd24;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S97:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S98:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S99:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S100:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S101:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S102:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S103:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S104:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S105:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S106:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S107:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S108:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S109:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S110:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S111:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S112:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd28;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S113:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S114:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S115:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S116:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S117:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S118:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S119:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S120:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S121:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S122:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S123:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S124:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S125:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S126:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S127:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S128:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd32;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S129:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S130:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S131:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S132:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S133:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S134:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S135:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S136:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S137:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S138:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S139:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S140:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S141:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S142:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S143:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S144:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd36;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S145:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S146:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S147:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S148:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S149:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S150:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S151:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S152:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S153:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S154:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S155:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S156:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S157:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S158:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S159:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S160:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd40;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S161:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S162:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S163:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S164:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S165:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S166:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S167:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S168:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S169:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S170:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S171:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S172:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S173:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S174:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S175:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S176:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd44;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S177:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S178:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S179:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S180:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S181:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S182:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S183:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S184:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S185:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S186:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S187:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S188:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S189:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S190:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S191:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S192:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd48;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S193:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S194:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S195:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S196:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S197:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S198:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S199:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S200:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S201:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S202:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S203:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S204:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S205:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S206:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S207:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S208:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd52;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S209:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S210:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S211:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S212:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S213:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S214:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S215:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S216:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S217:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S218:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S219:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S220:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S221:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S222:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S223:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S224:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd56;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S225:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S226:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S227:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S228:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S229:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S230:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S231:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S232:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S233:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S234:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S235:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S236:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S237:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S238:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S239:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S240:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd60;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b1;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S241:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd4;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S242:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd8;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S243:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd12;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S244:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd16;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S245:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd20;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S246:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd24;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S247:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd28;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S248:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd32;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S249:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd36;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S250:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd40;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S251:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd44;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S252:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd48;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S253:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd52;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S254:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd56;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			S255:
			begin
				case(PU)
					3'd0:
					begin
						TOP_RIGHT <= 8'd60;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b1;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b1;
					end
					3'd1:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b1;
						TOP_VALID <= 1'b0;
					end
					3'd2:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					3'd3:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
					default:
					begin
						TOP_RIGHT <= 8'd64;
						BOTTOM_LEFT <= 8'd64;
						DCVAL_flag <= 1'b0;
						LEFT_VALID <= 1'b0;
						TOP_VALID <= 1'b0;
					end
				endcase
			end
			default:
			begin
				TOP_RIGHT <= 8'd64;
				BOTTOM_LEFT <= 8'd64;
				DCVAL_flag <= 1'b1;
				LEFT_VALID <= 1'b0;
				TOP_VALID <= 1'b0;
			end
		endcase
	end
endmodule
