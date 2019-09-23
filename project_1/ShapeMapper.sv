// Quartus Prime SystemVerilog Template
//
// Simple Dual-Port RAM with different read/write addresses and single read/write clock
// and with a control for writing single bytes into the memory word; byte enable

// Changed to Read_only
module Pikachu
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 9
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/Pikachu.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : Pikachu


// Changed to Read_only
module Squirtle
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 9
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/Squirtle.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : Squirtle

module Bomb
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 24
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/Bomb3.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : Bomb

module Machop
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 9
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/machop.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : Machop


module Charmander
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 9
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/Charmander.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : Charmander


module Wall
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 24
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/wall_0.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : Wall

module Path
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 9
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/bg_3.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : Path

module Wood
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 24
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/wood_2.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : Wood

module fire
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 9
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/exp.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : fire

module blueBox
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 9
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/blueBox.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : blueBox

module redBox
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 9
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/redBox.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : redBox

module numbers
	#(parameter int
		ADDR_WIDTH = 14,
		DATA_WIDTH = 9
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/numbers.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : numbers

module cd
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 24
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/cd.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : cd

module Delay
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 24
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/delay.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : Delay

module speed
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 24
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/speed.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : speed

module range
	#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 24
)
( 
//	input logic [ADDR_WIDTH-1:0] waddr,
	input logic [ADDR_WIDTH-1:0] raddr,
//	input logic [DATA_WIDTH-1:0] wdata, 
//	input logic we,
	input logic clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a packed array to model memory
	logic [DATA_WIDTH-1:0] rom[0:WORDS-1];
	
	initial begin
		$readmemb("ReadyToUse/range.txt", rom);
	end

	always_ff@(posedge clk)
	begin
		q <= rom[raddr];
	end
endmodule : range

module ShapeMapper
#(parameter int
		ADDR_WIDTH = 10,
		DATA_WIDTH = 24
)
( 
	input logic [ADDR_WIDTH-1:0] raddr,
	input logic clk,
	input logic [7:0] Item_ID,
	output logic [DATA_WIDTH - 1:0] q
);
	logic [DATA_WIDTH-1:0] wallrgb, wrgb, brgb;
	
	logic [8:0] exprgb, prgb, bcrgb, rcrgb;
	
	Wall wall1(.raddr, .clk, .q(wallrgb/*qall[8'h00]*/));
	Path path1(.raddr, .clk, .q(prgb/*qall[8'h80]*/));
	Wood wood1(.raddr, .clk, .q(wrgb/*qall[8'h10]*/));
	Bomb bomb1(.raddr, .clk, .q(brgb/*qall[8'h60]*/));
	blueBox blue(.raddr, .clk, .q(bcrgb/*qall[8'h90]*/));
	redBox red(.raddr, .clk, .q(rcrgb/*qall[8'h91]*/));
	fire exp01(.raddr, .clk, .q(exprgb));
	
	
//	assign qall[8'h40] = exp_ID;
//	assign qall[8'h48] = exp_ID;
//	assign q = qall[Item_ID];
	
	always_comb begin
		q = 24'h000000;
		unique case(Item_ID)
			8'h00: q = wallrgb;
			8'h80: q = {prgb[8:6],5'h10,prgb[5:3],5'h10,prgb[2:0],5'h10};
			8'h10: q = wrgb;
			8'h60: q = brgb;
			8'h90: q = {bcrgb[8:6],5'h10,bcrgb[5:3],5'h10,bcrgb[2:0],5'h10};
			8'h91: q = {rcrgb[8:6],5'h10,rcrgb[5:3],5'h10,rcrgb[2:0],5'h10};
			8'h40,
			8'h48: q = {exprgb[8:6],5'h10,exprgb[5:3],5'h10,exprgb[2:0],5'h10};
		endcase
	end
	
endmodule
