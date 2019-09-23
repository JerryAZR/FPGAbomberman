// Quartus Prime SystemVerilog Template
//
// Simple due-Port RAM with different read/write addresses and single read/write clock
// and with a control for writing single bytes into the memory word

module Map
	#(parameter int
		ADDR_WIDTH = 8,
		DATA_WIDTH = 8
)
( 
	input [ADDR_WIDTH-1:0] waddr,
	input [ADDR_WIDTH-1:0] raddr,
	input [DATA_WIDTH-1:0] wdata, 
	input we, clk,
	output logic [DATA_WIDTH - 1:0] q
);
	localparam int WORDS = 1 << ADDR_WIDTH ;

	// use a multi-dimensional packed array to model individue bytes within the word
	logic [DATA_WIDTH-1:0] map [0:WORDS-1];
	
	initial begin
		$readmemh("ReadyToUse/map2.csv", map);
	end
	
	always_ff@(posedge clk)
	begin
		if(we) begin
		// edit this code if using other than four bytes per word
			map[waddr] <= wdata;
		end
		q <= map[raddr];
	end
endmodule : Map

module NeighborID (
	input logic [9:0] X_Pos, Y_Pos, Step,
	input logic [7:0] waddr, wdata,
	input logic we, clk,
	output logic up, down, left, right
);
	logic [7:0] full_up0, full_down0, full_right0, full_left0;
	logic [7:0] full_up1, full_down1, full_right1, full_left1;
	
	logic [3:0] X_Map_Pos0, Y_Map_Pos0, X_Map_Pos1, Y_Map_Pos1;
	logic [9:0] X_prev, Y_prev, X_next, Y_next;
	
	assign X_prev = X_Pos-Step;
	assign Y_prev = Y_Pos-Step;
	assign X_next = X_Pos+Step+10'h020;
	assign Y_next = Y_Pos+Step+10'h020;
	assign X_Map_Pos0 = X_Pos[8:5] + {{{3{1'b0}},X_Pos[4] & X_Pos[3]}};
	assign Y_Map_Pos0 = Y_Pos[8:5] + {{{3{1'b0}},Y_Pos[4] & Y_Pos[3]}};
	assign X_Map_Pos1 = X_Pos[8:5] + {{{3{1'b0}},X_Pos[4] | X_Pos[3]}};
	assign Y_Map_Pos1 = Y_Pos[8:5] + {{{3{1'b0}},Y_Pos[4] | Y_Pos[3]}};
	// DrawY[8:5], DrawX[8:5]
	Map map_up(.waddr, .raddr({Y_prev[8:5], X_Map_Pos0}), .wdata, .q(full_up0), .we, .clk);
	Map map_down(.waddr, .raddr({Y_next[8:5], X_Map_Pos0}), .wdata, .q(full_down0), .we, .clk);
	Map map_left(.waddr, .raddr({Y_Map_Pos0, X_prev[8:5]}), .wdata, .q(full_left0), .we, .clk);
	Map map_rignt(.waddr, .raddr({Y_Map_Pos0, X_next[8:5]}), .wdata, .q(full_right0), .we, .clk);
	
	Map map_u(.waddr, .raddr({Y_prev[8:5], X_Map_Pos1}), .wdata, .q(full_up1), .we, .clk);
	Map map_d(.waddr, .raddr({Y_next[8:5], X_Map_Pos1}), .wdata, .q(full_down1), .we, .clk);
	Map map_l(.waddr, .raddr({Y_Map_Pos1, X_prev[8:5]}), .wdata, .q(full_left1), .we, .clk);
	Map map_r(.waddr, .raddr({Y_Map_Pos1, X_next[8:5]}), .wdata, .q(full_right1), .we, .clk);
	
	assign up 		= full_up0[7] & full_up1[7];
	assign down 	= full_down0[7] & full_down1[7];
	assign left 	= full_left0[7] & full_left1[7];
	assign right 	= full_right0[7] & full_right1[7];
	
endmodule

module MapEditor (
	input logic WE0, WE1, WE2, WE3, WE4, WE5,// add more if necessary
	input logic [7:0] addr0, addr1, addr2, addr3, addr4, addr5,
	input logic [7:0] data0, data1, data2, data3, data4, data5,// 0 = highest priority
	input logic Clk, Reset, ROM_Clk,
	output logic WE,
	output logic [7:0] MapWriteAddr, MapWriteData
);

	enum logic [1:0] {RUNNING, RESETTING} state, next;
	logic [7:0] reset_addr, reset_val; 
	logic [7:0] first, second, third, fourth, fifth, sixth; // data variables
	logic [7:0] uno, song, sarasa, quatre, funf, seox; // address variables
	logic [7:0] addr [32];
	logic [7:0] data [32];
	logic [4:0] readPtr, writePtr, readPtr_next, writePtr_next;
	logic [5:0] count, count_next;

	Map read_only(.waddr(8'hxx), .raddr(reset_addr), .wdata(8'hxx), .q(reset_val), .we(1'b0), .clk(ROM_Clk));
//	initial begin
//		count_next = {5{1'b0}};
//		readPtr_next = {4{1'b0}};
//		writePtr_next = {4{1'b0}};
//	end
	
	always_ff @(posedge Clk) begin
		if(Reset) begin
			state <= RESETTING;
			count <= {6{1'b0}};
			readPtr <= {5{1'b0}};
			writePtr <= {5{1'b0}};
			reset_addr <= 8'h00;
		end 
		else begin
			count <= count_next;
			readPtr <= readPtr_next;
			writePtr <= writePtr_next;
			state <= next;
			reset_addr <= reset_addr + 1;
			
			data[writePtr] 		<= first;
			data[writePtr+5'h01] <= second;
			data[writePtr+5'h02] <= third;
			data[writePtr+5'h03] <= fourth;
			data[writePtr+5'h04] <= fifth;
			data[writePtr+5'h05] <= sixth;
			
			addr[writePtr]   	<= uno;
			addr[writePtr+5'h1] <= song;
			addr[writePtr+5'h2] <= sarasa;
			addr[writePtr+5'h3] <= quatre;
			addr[writePtr+5'h4] <= funf;
			addr[writePtr+5'h5] <= seox;
		end
	end
	
	always_comb begin
		// default values:
		count_next = count - 6'd1 + {5'h0,WE0} + {5'h0,WE1} + {5'h0,WE2} + {5'h0,WE3} + {5'h0,WE4} + {5'h0,WE5};
		readPtr_next = readPtr + 5'd1;
		writePtr_next = writePtr + {4'h0,WE0} + {4'h0,WE1} + {4'h0,WE2} + {4'h0,WE3} + {4'h0,WE4} + {4'h0,WE5};
		next = RUNNING;
		MapWriteData = data[readPtr];
		MapWriteAddr = addr[readPtr];
		WE = count=={6{1'b0}} ? 1'b0 : 1'b1;
		
		first 	= data[writePtr];
		second 	= data[writePtr+5'h1];
		third 	= data[writePtr+5'h2];
		fourth 	= data[writePtr+5'h3];
		fifth 	= data[writePtr+5'h4];
		sixth 	= data[writePtr+5'h5];
		
		uno 	= addr[writePtr];
		song 	= addr[writePtr+5'h1];
		sarasa 	= addr[writePtr+5'h2];
		quatre 	= addr[writePtr+5'h3];
		funf 	= addr[writePtr+5'h4];
		seox 	= addr[writePtr+5'h5];
		
		if(state == RESETTING) begin
			MapWriteAddr = reset_addr;
			MapWriteData = reset_val;
			next = (reset_addr==8'hFF) ? RUNNING : RESETTING;
			count_next = 0;
			readPtr_next = 5'h0;
			writePtr_next = 5'h0;
			WE = 1'b1;
		end
		else begin	
			if(count == {6{1'b0}}) begin
				count_next = count + {5'h0,WE0} + {5'h0,WE1} + {5'h0,WE2} + {5'h0,WE3} + {5'h0,WE4} + {5'h0,WE5};
				readPtr_next = readPtr;
			end
			
			// assign first
			unique casex({WE0, WE1, WE2, WE3, WE4, WE5}) 
				6'b1xxxxx: begin first = data0; uno = addr0; end
				6'b01xxxx: begin first = data1; uno = addr1; end
				6'b001xxx: begin first = data2; uno = addr2; end
				6'b0001xx: begin first = data3; uno = addr3; end
				6'b00001x: begin first = data4; uno = addr4; end
				6'b000001: begin first = data5; uno = addr5; end
				default: ;
			endcase
			
			// assign second
			unique casex({WE0, WE1, WE2, WE3, WE4, WE5}) 
				6'b11xxxx: begin second = data1; song = addr1; end
				6'b101xxx, 
				6'b011xxx: begin second = data2; song = addr2; end
				6'b1001xx, 
				6'b0101xx,
				6'b0011xx: begin second = data3; song = addr3; end
				6'b10001x,
				6'b01001x,
				6'b00101x,
				6'b00011x: begin second = data4; song = addr4; end
				6'b100001,
				6'b010001,
				6'b001001,
				6'b000101,
				6'b000011: begin second = data5; song = addr5; end
				default: ;
			endcase
			
			// assign third
			unique casex({WE0, WE1, WE2, WE3, WE4, WE5})
				6'b111xxx: begin third = data2; sarasa = addr2; end
				6'b0111xx,
				6'b1011xx,
				6'b1101xx: begin third = data3; sarasa = addr3; end
				6'b11001x,
				6'b10101x,
				6'b10011x,
				6'b01101x,
				6'b01011x,
				6'b00111x: begin third = data4; sarasa = addr4; end
				6'b110001,
				6'b101001,
				6'b100101,
				6'b100011,
				6'b011001,
				6'b010101,
				6'b010011,
				6'b001101,
				6'b001011,
				6'b000111: begin third = data5; sarasa = addr5; end
				default: ;
			endcase
			
			// assign fourth
			unique casex({WE0, WE1, WE2, WE3, WE4, WE5})
				6'b1111xx: begin fourth = data3; quatre = addr3; end
				6'b11101x,
				6'b11011x,
				6'b10111x,
				6'b01111x: begin fourth = data4; quatre = addr4; end
				6'b111001,
				6'b110101,
				6'b101101,
				6'b011101,
				6'b110011,
				6'b101011,
				6'b011011,
				6'b100111,
				6'b010111,
				6'b001111: begin fourth = data5; quatre = addr5; end
				default: ;
			endcase
			
			// assign fifth
			unique casex({WE0, WE1, WE2, WE3, WE4, WE5})
				6'b11111x: begin fifth = data4; funf = addr4; end
				6'b111101,
				6'b111011,
				6'b110111,
				6'b101111,
				6'b011111: begin fifth = data5; funf = addr5; end
				default: ;
			endcase
			
			// assign sixth
			if({WE0, WE1, WE2, WE3, WE4, WE5} == 6'b111111) begin 
				sixth = data5;
				seox = addr5;
			end		

//			// simple logic:
//			WE = WE0 | WE1 | WE2 | WE3;
//			if(WE0) begin
//				MapWriteAddr = addr0;
//				MapWriteData = data0;
//			end else if (WE1) begin
//				MapWriteAddr = addr1;
//				MapWriteData = data1;
//			end else if (WE2) begin
//				MapWriteAddr = addr2;
//				MapWriteData = data2;
//			end else begin
//				MapWriteAddr = addr3;
//				MapWriteData = data3;
//			end
		end
	end

endmodule
