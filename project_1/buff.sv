/* Notes:
	time unit : 10'h010 = 1 second; 10'h008 = 0.5 second; ......
  more outputs can be added if necessary, and not all outputs have to be used;
  For unused outputs, set the values to a constant;
*/

/*
Default / Initial values:

	step = 10'd2;
  size = 2'b00; // (total width & height = 3 blocks)
  delay = 10'h030; // (3 seconds)
	cooldown = 10'h018; // (1.5s)
*/
module buff (
  input logic Clk, Reset, player, frame_clk, // player value is used to determine if an item can be picked up. (0 - P1; 1 - P2)
  input logic [7:0] id, 
  input logic [3:0] randhex,
  output logic WE, // set to 1 when an item is picked up
  output logic [9:0] step, // character move speed
  output logic [1:0] size, // bomb explosion size
  output logic [9:0] delay, // time before explosion
  output logic [9:0] cooldown // time before the second bomb can be placed after the first one
);
//	assign WE = 1'b0;
//	assign step = 10'd2;
//	assign size = 2'b00;
//	assign delay = 10'h030;
//	assign cooldown = 10'h018;
	
	parameter [9:0] step_max = 10'd5;
	parameter [9:0] step_min = 10'd1;
	parameter [9:0] delay_max = 10'h050;
	parameter [9:0] delay_min = 10'h010;
	parameter [9:0] cooldown_max = 10'h050;
	parameter [9:0] cooldown_min = 10'h010;
	
	logic [9:0] step_next, delay_next, cooldown_next;
	logic [1:0] size_next;
	logic [7:0] item;
	logic debuff, WE_next;
	logic [3:0] randh;
	
	// Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	
	assign item = {4'h9, 3'b000, player};
	assign debuff = randh[1] & randh[0];
	
	always_ff @ (posedge Clk) begin
		if(Reset) begin
			step <= 10'd3;
			size <= 2'b01;
			delay <= 10'h030;
			cooldown <= 10'h018;
			WE <= 1'b0;
		end
		else begin
			step <= step_next;
			delay <= delay_next;
			cooldown <= cooldown_next;
			size <= size_next;
			WE <= WE_next;
		end
		randh <= randhex;
	end
	
	always_comb begin
		WE_next = 1'b0;
		step_next = step;
		delay_next = delay;
		cooldown_next = cooldown;
		size_next = size;
		
		if(id == item && frame_clk_rising_edge) begin
			WE_next = 1'b1;
			unique case(randh[3:2]) 
				2'b00: begin // change step
					if (debuff) step_next = (step==step_min)? step : (step-10'd1);
					else step_next = (step==step_max)? step : (step+10'd1);
				end
				
				2'b01: begin // change delay
					if (debuff) delay_next = (delay==delay_max)? delay : (delay+10'h008);
					else delay_next = (delay==delay_min)? delay : (delay-10'h008);
				end
				
				2'b10: begin // change cooldown
					if (debuff) cooldown_next = (cooldown==cooldown_max)? cooldown : (cooldown+10'h008);
					else cooldown_next = (cooldown==cooldown_min)? cooldown : (cooldown-10'h008);
				end
				
				2'b11: begin // change size
					if (debuff) size_next = (size==2'b00) ? size : (size-2'b01);
					else size_next = (size==2'b11) ? size : (size+2'b01);
				end
				
				default: ;
			endcase
		end
	end
  
endmodule
