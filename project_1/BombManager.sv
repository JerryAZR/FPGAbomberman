module BombManager (
	input logic Clk, Reset,
	input logic p1bomb, p2bomb,
	input logic [9:0] timer, cooldown1, cooldown2, delay1, delay2,
	input logic [9:0] Char1_X_Pos, Char1_Y_Pos, Char2_X_Pos, Char2_Y_Pos,
	input logic [7:0] id1, id2,
	input logic [1:0] p1size, p2size, 
	input logic [3:0] randhex,
	output logic WE0, WE1, WE2, WE3,
	output logic [7:0] addr0, addr1, addr2, addr3, data0, data1, data2, data3,
	output logic p1gain, p2gain
);

//	parameter [9:0] cooldown = 10'h018; // 1.5 seconds
	parameter wall = 8'h00;
    parameter path = 8'h80;
    parameter wood = 8'h10;
    parameter explosion = 4'h4;

	logic [7:0] bomb_addr1, bomb_addr2;
	logic [9:0] exp_t1, exp_t2;
	logic [1:0] p1size_out, p2size_out;
	logic trigger1, trigger2, p1full, p2full, p1empty, p2empty, t1, t2;
//	assign p1size = 2'b10;
//	assign p2size = 2'b01;
	queue #(.ADDR_WIDTH(8), .DATA_WIDTH(8)) addr_q2(.in(addr2), .out(bomb_addr1), .we(WE2), .Clk, .Reset, .next(trigger1 & t1), .empty(p1empty), .full(p1full));
	queue #(.ADDR_WIDTH(8), .DATA_WIDTH(10)) time_q2(.in(timer+delay1), .out(exp_t1), .we(WE2), .Clk, .Reset, .next(trigger1 & t1), .empty(), .full());
	queue #(.ADDR_WIDTH(8), .DATA_WIDTH(2)) size_q2(.in(p1size), .out(p1size_out), .we(WE2), .Clk, .Reset, .next(trigger1 & t1), .empty(), .full());

	queue #(.ADDR_WIDTH(8), .DATA_WIDTH(8)) addr_q3(.in(addr3), .out(bomb_addr2), .we(WE3), .Clk, .Reset, .next(trigger2 & t2), .empty(p2empty), .full(p2full));
	queue #(.ADDR_WIDTH(8), .DATA_WIDTH(10)) time_q3(.in(timer+delay2), .out(exp_t2), .we(WE3), .Clk, .Reset, .next(trigger2 & t2), .empty(), .full());
	queue #(.ADDR_WIDTH(8), .DATA_WIDTH(2)) size_q3(.in(p2size), .out(p2size_out), .we(WE3), .Clk, .Reset, .next(trigger2 & t2), .empty(), .full());

	explosion exp1(.clk(Clk), .ready(trigger1), .length_in(p1size_out), .Data_IN(id1), .coordinate(bomb_addr1),
	.WE_O(WE0), .Data_O(data0), .Address(addr0), .timer, .player(1'b0), .randhex, .t(t1));
	explosion exp2(.clk(Clk), .ready(trigger2), .length_in(p2size_out), .Data_IN(id2), .coordinate(bomb_addr2),
	.WE_O(WE1), .Data_O(data1), .Address(addr1), .timer, .player(1'b1), .randhex, .t(t2));

	logic [3:0] Char1_X_Map_Pos, Char1_Y_Map_Pos;
	logic [3:0] Char2_X_Map_Pos, Char2_Y_Map_Pos;
	logic [9:0] p1time, p2time, p1time_next, p2time_next; // the time when last bomb was placed
	logic p1ready, p2ready, p1ready_next, p2ready_next;

	enum logic [7:0] {START, SET, WAIT} state1, next1, state2, next2;

	assign Char1_X_Map_Pos = {(Char1_X_Pos[8:5] + {{3{1'b0}},Char1_X_Pos[4]})};
	assign Char1_Y_Map_Pos = {(Char1_Y_Pos[8:5] + {{3{1'b0}},Char1_Y_Pos[4]})};
	assign Char2_X_Map_Pos = {(Char2_X_Pos[8:5] + {{3{1'b0}},Char2_X_Pos[4]})};
	assign Char2_Y_Map_Pos = {(Char2_Y_Pos[8:5] + {{3{1'b0}},Char2_Y_Pos[4]})};

	assign addr2 = {Char1_Y_Map_Pos, Char1_X_Map_Pos};
	assign addr3 = {Char2_Y_Map_Pos, Char2_X_Map_Pos};

	assign data2 = 8'h60;
	assign data3 = 8'h60;

//	assign delay1 = 10'h030;
//	assign delay2 = 10'h030;

	always_ff @ (posedge Clk) begin
		state1 <= Reset? START : next1;
		state2 <= Reset? START : next2;

		p1time <= p1time_next;
		p2time <= p2time_next;
		p1ready <= p1ready_next;
		p2ready <= p2ready_next;
		
	end

	always_comb begin
		// assign default values:

		p1time_next = p1time;
		p2time_next = p2time;
		p1ready_next = p1ready;
		p2ready_next = p2ready;
		next1 = state1;
		next2 = state2;

		trigger1 = (timer==exp_t1 && ~p1empty) ? 1'b1 : 1'b0;
		trigger2 = (timer==exp_t2 && ~p2empty) ? 1'b1 : 1'b0;

		WE2 = 1'b0;
		WE3 = 1'b0;
		
		p1gain = 1'b0;
		p2gain = 1'b0;
		
		if(WE0 && addr0 == {Char1_Y_Map_Pos,Char1_X_Map_Pos} && data0[7:4] == explosion) p2gain = 1'b1;
		if(WE1 && addr1 == {Char1_Y_Map_Pos,Char1_X_Map_Pos} && data1[7:4] == explosion) p2gain = 1'b1;
		if(WE0 && addr0 == {Char2_Y_Map_Pos,Char2_X_Map_Pos} && data0[7:4] == explosion) p1gain = 1'b1;
		if(WE1 && addr1 == {Char2_Y_Map_Pos,Char2_X_Map_Pos} && data1[7:4] == explosion) p1gain = 1'b1;

		unique case(state1)
			START: begin
				// check if cooldown ends
				if(timer[7:0] == p1time[7:0]) begin
					p1ready_next = 1'b1;
				end

				if(p1ready && p1bomb && ~p1full) next1 = SET;
			end

			SET: begin
				WE2 = 1'b1;
				next1 = WAIT;
				p1time_next = timer+cooldown1; // start timer
				p1ready_next = 1'b0;
			end

			WAIT: begin
				next1 = p1bomb? WAIT : START;
				if(timer[7:0] == p1time[7:0]) begin
					p1ready_next = 1'b1;
				end
			end
		endcase


		unique case(state2)
			START: begin
				// check if cooldown ends
				if(timer[7:0] == p2time[7:0]) begin
					p2ready_next = 1'b1;
				end

				if(p2ready && p2bomb && ~p2full) next2 = SET;
			end

			SET: begin
				WE3 = 1'b1;
				next2 = WAIT;
				p2time_next = timer+cooldown2; // start timer
				p2ready_next = 1'b0;
			end

			WAIT: begin
				next2 = p2bomb? WAIT : START;
				if(timer[7:0] == p2time[7:0]) begin
					p2ready_next = 1'b1;
				end
			end
		endcase
	end

endmodule
