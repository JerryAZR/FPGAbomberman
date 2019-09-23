//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( 	input logic 	is_Char1, is_Char2, ROM_Clk, dir1, dir2, p1red, p2red, 
						input logic [9:0] Char1_step, Char2_step,
						input logic [1:0] bomb1_size, bomb2_size,
						input logic [9:0] delay1, delay2, cooldown1, cooldown2,
						input logic [9:0] DrawX, DrawY, Char1_X_Pos, Char1_Y_Pos, Char2_X_Pos, Char2_Y_Pos,     // Current pixel coordinates
						input logic	[7:0] p1score, p2score,
						output logic [7:0] VGA_R, VGA_G, VGA_B, // VGA RGB output
						input logic [23:0] defaultRGB
                     );
    
    logic [7:0] Red, Green, Blue;
    logic [8:0] simpleRGB1, simpleRGB2, RightRGB1, RightRGB2, ScoreRGB11, ScoreRGB12, ScoreRGB21, ScoreRGB22,
		stepRGB1, stepRGB2, sizeRGB1, sizeRGB2, delayRGB1, delayRGB2, coolRGB1, coolRGB2;
	logic [23:0] DRGB, SRGB, RRGB, CRGB;
	logic [4:0] relativeX1, relativeY1, relativeX2, relativeY2, shapeX, shapeY;
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    assign relativeX1 = (DrawX-Char1_X_Pos) ^ {32{dir1}};
	assign relativeY1 = (DrawY-Char1_Y_Pos);
	assign relativeX2 = (DrawX-Char2_X_Pos) ^ {32{dir2}};
	assign relativeY2 = (DrawY-Char2_Y_Pos);
	
	Squirtle char1_figure(.raddr({relativeX1,relativeY1}), .clk(ROM_Clk), .q(simpleRGB1));
	Squirtle char1_static(.raddr({DrawX[4:0],DrawY[4:0]}), .clk(ROM_Clk), .q(RightRGB1));
		
	Charmander char2_figure(.raddr({relativeX2,relativeY2}), .clk(ROM_Clk), .q(simpleRGB2));
	Charmander char2_static(.raddr({DrawX[4:0],DrawY[4:0]}), .clk(ROM_Clk), .q(RightRGB2));
	
	numbers score11(.raddr({p1score[3:0], DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(ScoreRGB11));
	numbers score12(.raddr({p1score[7:4], DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(ScoreRGB12));
	numbers score21(.raddr({p2score[3:0], DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(ScoreRGB21));
	numbers score22(.raddr({p2score[7:4], DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(ScoreRGB22));
	
	Delay buff_delay(.raddr({DrawX[4:0],DrawY[4:0]}), .clk(ROM_Clk), .q(DRGB));
	speed buff_speed(.raddr({DrawX[4:0],DrawY[4:0]}), .clk(ROM_Clk), .q(SRGB));
	range buff_range(.raddr({DrawX[4:0],DrawY[4:0]}), .clk(ROM_Clk), .q(RRGB));
	cd buff_cooldown(.raddr({DrawX[4:0],DrawY[4:0]}), .clk(ROM_Clk), .q(CRGB));
	
	numbers step1(.raddr({Char1_step[3:0], DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(stepRGB1));
	numbers step2(.raddr({Char2_step[3:0], DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(stepRGB2));
	numbers size1(.raddr({{2'b00,bomb1_size}+4'h1, DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(sizeRGB1));
	numbers size2(.raddr({{2'b00,bomb2_size}+4'h1, DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(sizeRGB2));
	numbers delayA(.raddr({delay1[6:3], DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(delayRGB1));
	numbers delayB(.raddr({delay2[6:3], DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(delayRGB2));
	numbers cool1(.raddr({cooldown1[6:3], DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(coolRGB1));
	numbers cool2(.raddr({cooldown2[6:3], DrawX[4:0], DrawY[4:0]}), .clk(ROM_Clk), .q(coolRGB2));
	
    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_Char1 == 1'b1 && simpleRGB1 != 9'h1FF) 
        begin
			Red = {simpleRGB1[8:6], 5'b10000};
			Green = p1red? 8'h00 : {simpleRGB1[5:3], 5'b10000};
			Blue = p1red? 8'h00 : {simpleRGB1[2:0], 5'b10000};
        end
		else if (is_Char2 == 1'b1 && simpleRGB2 !=9'h1FF)
		begin
			Red = {simpleRGB2[8:6], 5'b10000};
			Green = p2red? 8'h00 : {simpleRGB2[5:3], 5'b10000};
			Blue = p2red? 8'h00 : {simpleRGB2[2:0], 5'b10000};
        end
        else if (DrawX < 10'd480) begin
			Red = defaultRGB[23:16];
			Green = defaultRGB[15:8];
			Blue = defaultRGB[7:0];
		end
		else begin
			Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
			unique case({DrawX[9:5],DrawY[9:5]})
				{5'd17,5'd8},
				{5'd16,5'd2}: begin // P1 figure
					Red = {RightRGB1[8:6], 5'b10000};
					Green = {RightRGB1[5:3], 5'b10000};
					Blue = {RightRGB1[2:0], 5'b10000};
				end 
				{5'd18,5'd8},
				{5'd16,5'd4}: begin // P2 figure
					Red = {RightRGB2[8:6], 5'b10000};
					Green = {RightRGB2[5:3], 5'b10000};
					Blue = {RightRGB2[2:0], 5'b10000};
				end
				{5'd18,5'd2}: begin // P1 Score
					Red = {ScoreRGB11[8:6], 5'b10000};
					Green = {ScoreRGB11[5:3], 5'b10000};
					Blue = {ScoreRGB11[2:0], 5'b10000};
				end
				{5'd17,5'd2}: begin // P1 Score
					Red = {ScoreRGB12[8:6], 5'b10000};
					Green = {ScoreRGB12[5:3], 5'b10000};
					Blue = {ScoreRGB12[2:0], 5'b10000};
				end
				{5'd18,5'd4}: begin // P2 Score
					Red = {ScoreRGB21[8:6], 5'b10000};
					Green = {ScoreRGB21[5:3], 5'b10000};
					Blue = {ScoreRGB21[2:0], 5'b10000};
				end
				{5'd17,5'd4}: begin // P2 Score
					Red = {ScoreRGB22[8:6], 5'b10000};
					Green = {ScoreRGB22[5:3], 5'b10000};
					Blue = {ScoreRGB22[2:0], 5'b10000};
				end
				{5'd16,5'd8}: begin // Top-left cornor of buff board
					Red = 8'hF0;
					Green = 8'hF0;
					Blue = 8'hF0;
				end
				{5'd16,5'd9}: begin // step size symbol
					Red = SRGB[23:16];
					Green = SRGB[15:8];
					Blue = SRGB[7:0];
				end
				{5'd17,5'd9}: begin // P1 step size
					Red = {stepRGB1[8:6], 5'b10000};
					Green = {stepRGB1[5:3], 5'b10000};
					Blue = {stepRGB1[2:0], 5'b10000};
				end
				{5'd18,5'd9}: begin // P2 step size
					Red = {stepRGB2[8:6], 5'b10000};
					Green = {stepRGB2[5:3], 5'b10000};
					Blue = {stepRGB2[2:0], 5'b10000};
				end
				{5'd16,5'd10}: begin // explosion range symbol
					Red = RRGB[23:16];
					Green = RRGB[15:8];
					Blue = RRGB[7:0];
				end
				{5'd17,5'd10}: begin // P1 bomb exp range
					Red = {sizeRGB1[8:6], 5'b10000};
					Green = {sizeRGB1[5:3], 5'b10000};
					Blue = {sizeRGB1[2:0], 5'b10000};
				end
				{5'd18,5'd10}: begin // P2 bomb exp range
					Red = {sizeRGB2[8:6], 5'b10000};
					Green = {sizeRGB2[5:3], 5'b10000};
					Blue = {sizeRGB2[2:0], 5'b10000};
				end
				{5'd16,5'd11}: begin // delay symbol
					Red = DRGB[23:16];
					Green = DRGB[15:8];
					Blue = DRGB[7:0];
				end
				{5'd17,5'd11}: begin // P1 delay
					Red = {delayRGB1[8:6], 5'b10000};
					Green = {delayRGB1[5:3], 5'b10000};
					Blue = {delayRGB1[2:0], 5'b10000};
				end
				{5'd18,5'd11}: begin // P2 delay
					Red = {delayRGB2[8:6], 5'b10000};
					Green = {delayRGB2[5:3], 5'b10000};
					Blue = {delayRGB2[2:0], 5'b10000};
				end
				{5'd16,5'd12}: begin // cooldown symbol
					Red = CRGB[23:16];
					Green = CRGB[15:8];
					Blue = CRGB[7:0];
				end
				{5'd17,5'd12}: begin // P1 cooldown
					Red = {coolRGB1[8:6], 5'b10000};
					Green = {coolRGB1[5:3], 5'b10000};
					Blue = {coolRGB1[2:0], 5'b10000};
				end
				{5'd18,5'd12}: begin // P2 cooldown
					Red = {coolRGB2[8:6], 5'b10000};
					Green = {coolRGB2[5:3], 5'b10000};
					Blue = {coolRGB2[2:0], 5'b10000};
				end
				default: ;
			endcase
		end
    end 
    
endmodule
