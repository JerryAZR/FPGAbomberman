module ScoreBoard (
	input logic Clk, Reset, 
	input logic p1gain, p2gain,
	output logic [7:0] p1score, p2score
);


	logic [7:0] p1score_next, p2score_next;
	always_ff @(posedge Clk) begin
		if(Reset) begin
			p1score <= 8'h00;
			p2score <= 8'h00;
		end else begin
			p1score <= p1score_next;
			p2score <= p2score_next;
		end
	end
	
	always_comb begin
		p1score_next = p1score + {7'h00, p1gain};
		p2score_next = p2score + {7'h00, p2gain};
		if(p1score[3:0] == 4'h9 && p1gain) begin
			p1score_next[3:0] = 4'h0;
			p1score_next[7:4] = p1score[7:4] + 4'h1;
		end
		if(p2score[3:0] == 4'h9 && p2gain) begin
			p2score_next[3:0] = 4'h0;
			p2score_next[7:4] = p2score[7:4] + 4'h1;
		end
	end

endmodule

//		p1score <= Reset? 8'h00 : (p1score + {{7{1'b0}},p1gain}); 
//		p2score <= Reset? 8'h00 : (p2score + {{7{1'b0}},p2gain});