module queue #(parameter int ADDR_WIDTH = 8,DATA_WIDTH = 8)
(
	input logic [DATA_WIDTH-1:0] in,
	input logic we, Clk, Reset, next,
	output logic [DATA_WIDTH-1:0] out,
	output logic empty, full
);

	logic [DATA_WIDTH-1:0] mem [ADDR_WIDTH];
	logic [ADDR_WIDTH-1:0] readPtr, writePtr;
	logic [ADDR_WIDTH  :0] count;
	
	always_ff @(posedge Clk) begin
		if(Reset) begin
			count <= {(ADDR_WIDTH+1){1'b0}};
			readPtr <= {ADDR_WIDTH{1'b0}};
			writePtr <= {ADDR_WIDTH{1'b0}};
		end 
		else begin
			if(we && ~full) begin
				mem[writePtr] <= in;
				writePtr <= writePtr + 1;
				count <= count + 1;
			end
			if(next && ~empty) begin
				readPtr <= readPtr + 1;
				count <= count - 1;
			end
			
		end
	end
	
	assign empty = count=={(ADDR_WIDTH+1){1'b0}} ? 1'b1 : 1'b0;
	assign full = count == {1'b1, {ADDR_WIDTH{1'b0}}} ? 1'b1 : 1'b0;
	assign out = mem[readPtr];

endmodule
