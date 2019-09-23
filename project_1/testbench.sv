module testbench();


timeunit 10ns;
timeprecision 1ns;

//logic [7:0] in;
//logic we, Clk, Reset, next;
//logic [7:0] out;
//logic empty, full;
//	
//queue testunit(.*);

// inputs:
//logic WE0, WE1, WE2, WE3; // add more if necessary
//logic [7:0] addr0, addr1, addr2, addr3;
//logic [7:0] data0, data1, data2, data3; // 0 = highest priority
//logic Clk, Reset, ROM_Clk;
//logic [3:0] readPtr, writePtr;
////outputs:
//logic WE;
//logic [7:0] MapWriteAddr, MapWriteData;
//logic [4:0] count;

//MapEditor testunit(.*);
//assign readPtr = testunit.readPtr;
//assign writePtr = testunit.writePtr;
//assign count = testunit.count;

//always begin : ROM_CLOCK_GENERATION
//#1 ROM_Clk = ~ROM_Clk;
//end

// RNG test

logic Clk, Reset;
logic [3:0] randhex;
logic [15:0] zerocount, onecount, twocount, threecount, SW;

always_ff @(posedge Clk) begin
	if(Reset) begin
		zerocount <= 16'h0000;
		onecount <= 16'h0000;
		twocount <= 16'h0000;
		threecount <= 16'h0000;
	end else begin
		zerocount <= zerocount;
		onecount <= onecount;
		twocount <= twocount;
		threecount <= threecount;
		case(randhex[1:0])
			2'b00 : zerocount <= zerocount + 1;
			2'b01 : onecount <= onecount + 1;
			2'b10 : twocount <= twocount + 1;
			2'b11 : threecount <= threecount + 1;
		endcase
	end
end

assign SW = 16'h0123;
RNG random(.*, .seed(SW));
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin
    Clk = 0;
	Reset = 1;
end 

initial begin: TEST_VECTORS
#4	Reset = 0;


end


endmodule
