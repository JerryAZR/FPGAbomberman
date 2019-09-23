module explosion (
  	input logic clk, ready,
	input logic [9:0] timer,
   	input logic [1:0] length,
   	input logic [7:0] Data_IN, coordinate,
    output logic WE_O,
    output logic [7:0] Data_OUT, Address
);
    logic [2:0] count, count_next;
    logic [7:0] addr_next, coords, coords_next;
	logic WE_OUT;
	logic [9:0] clear_time, clear_time_next;
    enum logic [7:0] {START, UP, DOWN, LEFT, RIGHT, MID, REPLACE_UP, REPLACE_DOWN, REPLACE_LEFT, REPLACE_RIGHT, 
	WAIT, C_UP, C_DOWN, C_LEFT, C_RIGHT, CLEAR_UP, CLEAR_DOWN, CLEAR_LEFT, CLEAR_RIGHT, C_MID} state, next;
    //assign length = 1'b0; // for test
    parameter wall = 8'h00;
    parameter path = 8'h80;
    parameter wood = 8'h10;
    parameter explosion = 8'h40;


    always_ff @(posedge clk) begin
      state <= next;
      count <= count_next;
      Address <= addr_next;
	  WE_O <= WE_OUT;
	  coords <= coords_next;
	  clear_time <= clear_time_next;
    end


       always_comb begin
        // assign default later
			WE_OUT = 0;
			Data_OUT = explosion;
			addr_next = coords;
			next = START;
			count_next = 3'b111;
			coords_next = coords;
			clear_time_next = clear_time;
        // up
         unique case (state)


           START: begin
             if (ready) begin
				 next = UP;
				 count_next = 3'b111 - {{1'b1},length[1:0]};
				 coords_next = coordinate;
				 addr_next = coordinate;
				 clear_time_next = timer + 10'h010;
             end
				 else begin
				 WE_OUT = 0;
				 next = START;
				 end
           end
//           IDLE: next = UP;
           UP: begin
             if (count[2] == 0) begin
        		 addr_next = Address - 8'h10;
				 count_next = count + 1;
				 next = REPLACE_UP;
             end
             else begin
				 next = DOWN;
				 count_next = 3'b111 - {{1'b1},length[1:0]};
             end
           end

           DOWN: begin
             if (count[2] == 0) begin
        		 addr_next = Address + 8'h10;
				 count_next = count + 1;
				 next = REPLACE_DOWN;
             end
             else begin
				 next = LEFT;
				 count_next = 3'b111 - {{1'b1},length[1:0]};
             end
           end

           LEFT: begin
             if (count[2] == 0) begin
        		 addr_next = Address - 8'h01;
				 count_next = count + 1;
				 next = REPLACE_LEFT;
             end
             else begin
				 next = RIGHT;
				 count_next = 3'b111 - {{1'b1},length[1:0]};
             end
           end

           RIGHT: begin
             if (count[2] == 0) begin
        		 addr_next = Address + 8'h01;
				 count_next = count + 1;
				 next = REPLACE_RIGHT;
             end
             else begin
				 next = MID;
				 count_next = 3'b111 - {{1'b1},length[1:0]};
             end
           end

           MID: begin
             count_next = count;
             addr_next = Address;
             next = WAIT;
             WE_OUT = 1;
           end
           REPLACE_UP: begin
             if (Data_IN == path || Data_IN == explosion) begin
				count_next = count;
                WE_OUT = 1;
             end
			 else if (Data_IN == wood) begin
             	WE_OUT = 1; 
             end
				addr_next = Address;
				next = UP;
           end

			REPLACE_DOWN: begin
             if (Data_IN == path || Data_IN == explosion) begin
				count_next = count;
                WE_OUT = 1;
             end
			 else if (Data_IN == wood) begin
             	WE_OUT = 1; 
             end
				addr_next = Address;
				next = DOWN;
             end

           REPLACE_LEFT: begin
             if (Data_IN == path || Data_IN == explosion) begin
				count_next = count;
                WE_OUT = 1;
             end
			 else if (Data_IN == wood) begin
             	WE_OUT = 1; 
             end
				addr_next = Address;
				next = LEFT;
            end

           REPLACE_RIGHT: begin
             if (Data_IN == path || Data_IN == explosion) begin
				count_next = count;
                WE_OUT = 1;
             end
			 else if (Data_IN == wood) begin
             	WE_OUT = 1; 
             end
				addr_next = Address;
				next = RIGHT;
             end

			            	WAIT: begin
              if (timer == clear_time) begin
                next = C_UP;
                count_next = 3'b111 - {{1'b1},length[1:0]};
				coords_next = coordinate;
				addr_next = coordinate;
              end
              else begin
                next = WAIT;
              end
            end
           
           C_UP: begin
             if (count[2] == 0) begin
        		 addr_next = Address - 8'h10;
				 count_next = count + 1;
				 next = CLEAR_UP;
             end
             else begin
				 next = C_DOWN;
				 count_next = 3'b111 - {{1'b1},length[1:0]};
             end
           end  
           
           C_DOWN: begin
             if (count[2] == 0) begin
        		 addr_next = Address + 8'h10;
				 count_next = count + 1;
				 next = CLEAR_DOWN;
             end
             else begin
				 next = C_LEFT;
				 count_next = 3'b111 - {{1'b1},length[1:0]};
             end
           end
           
           C_LEFT: begin
             if (count[2] == 0) begin
        		 addr_next = Address - 8'h01;
				 count_next = count + 1;
				 next = CLEAR_LEFT;
             end
             else begin
				 next = C_RIGHT;
				 count_next = 3'b111 - {{1'b1},length[1:0]};
             end
           end
           
           C_RIGHT: begin
             if (count[2] == 0) begin
        		 addr_next = Address + 8'h01;
				 count_next = count + 1;
				 next = CLEAR_RIGHT;
             end
             else begin
				 next = C_MID;
				 count_next = 3'b111 - {{1'b1},length[1:0]};
             end
           end
           
           C_MID: begin
             count_next = count;
             addr_next = Address;
             next = START;
             Data_OUT = path;
             WE_OUT = 1;
           end
          
           CLEAR_UP: begin
             if (Data_IN == explosion) begin
				count_next = count;
                Data_OUT = path;
                WE_OUT = 1;
             end
             else begin
                WE_OUT = 0;
				addr_next = Address;
				next = C_UP;
             end
           end
             
			CLEAR_DOWN: begin
             if (Data_IN == explosion) begin
				count_next = count;
                Data_OUT = path;
                WE_OUT = 1;
             end
             else begin
                WE_OUT = 0;
				addr_next = Address;
				next = C_DOWN;
             end
           end
          
           	CLEAR_LEFT: begin
             if (Data_IN == explosion) begin
				count_next = count;
                Data_OUT = path;
                WE_OUT = 1;
             end
             else begin
                WE_OUT = 0;
				addr_next = Address;
				next = C_LEFT;
             end
           end
           
           CLEAR_RIGHT: begin
             if (Data_IN == explosion) begin
				count_next = count;
                Data_OUT = path;
                WE_OUT = 1;
             end
             else begin
                WE_OUT = 0;
				addr_next = Address;
				next = C_RIGHT;
             end
           end
         endcase
      end

endmodule
