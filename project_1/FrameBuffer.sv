// Quartus Prime SystemVerilog Template
//
// Simple Dual-Port RAM with different read/write addresses and single read/write clock
// and with a control for writing single bytes into the memory word; byte enable

module FrameBuffer
	#(parameter int
		ADDR_WIDTH = 17,
		DATA_WIDTH = 9
)
( 
	input [ADDR_WIDTH-1:0] waddr,
	input [ADDR_WIDTH-1:0] raddr,
	input [DATA_WIDTH-1:0] wdata, 
	input we, clk,
	output reg [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a multi-dimensional packed array to model individual bytes within the word
	logic [DATA_WIDTH-1:0] ram [0:WORDS-1];

	always_ff@(posedge clk)
	begin
		if(we) begin
			ram[waddr] <= wdata;
		end
		q <= ram[raddr];
	end
endmodule : FrameBuffer
