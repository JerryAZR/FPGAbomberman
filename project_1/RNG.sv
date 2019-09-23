module RNG(
	input logic Clk, Reset, 
	input logic [15:0] seed,
	output logic [3:0] randhex
);

	LFSR_16 rand0(.*, .a(seed), .randbit(randhex[0]));
	LFSR_13 rand1(.*, .a(seed[15:3]), .randbit(randhex[1]));
	LFSR_10 rand2(.*, .a(seed[15:6]), .randbit(randhex[2]));
	LFSR_14 rand3(.*, .a(seed[15:2]), .randbit(randhex[3]));

endmodule

module LFSR_16 (
	input logic Clk, Reset, 
	input logic [15:0] a,
	output logic randbit
);
	logic feedback;
	logic [15:0] lfsr_reg;
	
	assign feedback = lfsr_reg[0] ^ lfsr_reg[1] ^ lfsr_reg [3] ^ lfsr_reg[11];

	always_ff @(posedge Clk) begin
		if(Reset) begin
			lfsr_reg <= a;
		end else if(lfsr_reg == 16'h0000) begin
			lfsr_reg <= 16'h3456;
		end else begin
			lfsr_reg <= {feedback, lfsr_reg[15:1]};
		end
	end
	
	assign randbit = lfsr_reg[0];
		
endmodule

module LFSR_13 (
	input logic Clk, Reset, 
	input logic [12:0] a,
	output logic randbit
);
	logic feedback;
	logic [12:0] lfsr_reg;
	
	assign feedback = lfsr_reg[0] ^ lfsr_reg[1] ^ lfsr_reg [2] ^ lfsr_reg[5];

	always_ff @(posedge Clk) begin
		if(Reset) begin
			lfsr_reg <= a;
		end else if(lfsr_reg == 13'h0000) begin
			lfsr_reg <= 13'h1313;
		end else begin
			lfsr_reg <= {feedback, lfsr_reg[12:1]};
		end
	end
	
	assign randbit = lfsr_reg[0];
		
endmodule

module LFSR_14 (
	input logic Clk, Reset, 
	input logic [13:0] a,
	output logic randbit
);
	logic feedback;
	logic [13:0] lfsr_reg;
	
	assign feedback = lfsr_reg[0] ^ lfsr_reg[1] ^ lfsr_reg [2] ^ lfsr_reg[12];

	always_ff @(posedge Clk) begin
		if(Reset) begin
			lfsr_reg <= a;
		end else if(lfsr_reg == 14'h0000) begin
			lfsr_reg <= 14'h1414;
		end else begin
			lfsr_reg <= {feedback, lfsr_reg[13:1]};
		end
	end
	
	assign randbit = lfsr_reg[0];
		
endmodule

module LFSR_10 (
	input logic Clk, Reset, 
	input logic [9:0] a,
	output logic randbit
);
	logic feedback;
	logic [9:0] lfsr_reg;
	
	assign feedback = lfsr_reg[0] ^ lfsr_reg[3];

	always_ff @(posedge Clk) begin
		if(Reset) begin
			lfsr_reg <= a;
		end else if (lfsr_reg == 10'h000) begin
			lfsr_reg <= 10'h0AA;
		end else begin
			lfsr_reg <= {feedback, lfsr_reg[9:1]};
		end
	end
	
	assign randbit = lfsr_reg[0];
		
endmodule
