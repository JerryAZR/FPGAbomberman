module movement (
	input logic [15:0] keyA, keyB, keyC,
	output logic [7:0] p1move, p2move,
	output logic p1bomb, p2bomb
);
	
always_comb
begin
	p1move = 8'd00;
	p2move = 8'd00;
	p1bomb = 1'b0;
	p2bomb = 1'b0;
	case (keyA[7:0])
	8'd26: p1move = 8'd26; // W
	8'd04: p1move = 8'd04; // A
	8'd22: p1move = 8'd22; // S
	8'd07: p1move = 8'd07; // D
	8'd82: p2move = 8'd82; // UP
	8'd81: p2move = 8'd81; // DOWN
	8'd80: p2move = 8'd80; // LEFT
	8'd79: p2move = 8'd79; // RIGHT
	8'd53: p1bomb = 1'b1; // `/~
	8'd54: p2bomb = 1'b1; // ,/<
	default: ;
	endcase
	case (keyA[15:8])
	8'd26: p1move = 8'd26; // W
	8'd04: p1move = 8'd04; // A
	8'd22: p1move = 8'd22; // S
	8'd07: p1move = 8'd07; // D
	8'd82: p2move = 8'd82; // UP
	8'd81: p2move = 8'd81; // DOWN
	8'd80: p2move = 8'd80; // LEFT
	8'd79: p2move = 8'd79; // RIGHT
	8'd53: p1bomb = 1'b1; // `/~
	8'd54: p2bomb = 1'b1; // ,/<
	endcase
	case (keyB[7:0])
	8'd26: p1move = 8'd26; // W
	8'd04: p1move = 8'd04; // A
	8'd22: p1move = 8'd22; // S
	8'd07: p1move = 8'd07; // D
	8'd82: p2move = 8'd82; // UP
	8'd81: p2move = 8'd81; // DOWN
	8'd80: p2move = 8'd80; // LEFT
	8'd79: p2move = 8'd79; // RIGHT
	8'd53: p1bomb = 1'b1; // `/~
	8'd54: p2bomb = 1'b1; // ,/<
	endcase
	case (keyB[15:8])
	8'd26: p1move = 8'd26; // W
	8'd04: p1move = 8'd04; // A
	8'd22: p1move = 8'd22; // S
	8'd07: p1move = 8'd07; // D
	8'd82: p2move = 8'd82; // UP
	8'd81: p2move = 8'd81; // DOWN
	8'd80: p2move = 8'd80; // LEFT
	8'd79: p2move = 8'd79; // RIGHT
	8'd53: p1bomb = 1'b1; // `/~
	8'd54: p2bomb = 1'b1; // ,/<
	endcase
	case (keyC[7:0])
	8'd26: p1move = 8'd26; // W
	8'd04: p1move = 8'd04; // A
	8'd22: p1move = 8'd22; // S
	8'd07: p1move = 8'd07; // D
	8'd82: p2move = 8'd82; // UP
	8'd81: p2move = 8'd81; // DOWN
	8'd80: p2move = 8'd80; // LEFT
	8'd79: p2move = 8'd79; // RIGHT
	8'd53: p1bomb = 1'b1; // `/~
	8'd54: p2bomb = 1'b1; // ,/<
	endcase
	case (keyC[15:8])
	8'd26: p1move = 8'd26; // W
	8'd04: p1move = 8'd04; // A
	8'd22: p1move = 8'd22; // S
	8'd07: p1move = 8'd07; // D
	8'd82: p2move = 8'd82; // UP
	8'd81: p2move = 8'd81; // DOWN
	8'd80: p2move = 8'd80; // LEFT
	8'd79: p2move = 8'd79; // RIGHT
	8'd53: p1bomb = 1'b1; // `/~
	8'd54: p2bomb = 1'b1; // ,/<
	endcase
end
endmodule
