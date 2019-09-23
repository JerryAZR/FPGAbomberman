module hit(
	input logic Clk, Reset,
  input logic p1gain, p2gain, // p1gain indicates p2 get hit, and vise versa
  input logic [9:0] timer, // 10'h010 = 1 second
  output logic p1red, p2red
);
  
  // declare variables
  enum logic [1:0]{WAIT1, P1} state1, next1;
  enum logic [1:0]{WAIT2, P2} state2, next2;
  logic p1red_next, p2red_next;
  logic [9:0] time1 , time2, time1_next, time2_next;
  
  
  always_ff @(posedge Clk) begin
	if(Reset) begin
		state2 <= WAIT2;
		p2red <= 1'b0;
		time2 <= time2_next;
	end else begin
		state2 <= next2;
		p2red <= p2red_next; 
		time2 <= time2_next;
	end
  end
  
  always_comb begin
    // assign default values
    p2red_next = 1'b0;
    time2_next = timer;
    unique case (state2)
      
      WAIT2: begin
        if (p1gain == 1'b1) begin
          next2 = P2;
          p2red_next = 1'b1;
          time2_next = timer;
        end
        else next2 = WAIT2;
      end
      
      P2: begin
        if (timer == time2 + 10'h008) begin
          next2 = WAIT2;
          p2red_next = 1'b0;
        end
        else begin
          time2_next = p1gain? timer : time2;
          p2red_next = 1'b1;
          next2 = P2;
        end
      end
        
        endcase
      end
  
  
  always_ff @(posedge Clk) begin
	if(Reset) begin
		state1 <= WAIT1;
	    p1red <= 1'b0;
	    time1 <= time1_next;
	end else begin
		state1 <= next1;
		p1red <= p1red_next;
		time1 <= time1_next;
	end
  end
  
  always_comb begin
    // assign default values
    p1red_next = 1'b0;
    time1_next = timer;
    unique case (state1)
      
      WAIT1: begin
        if (p2gain == 1'b1) begin
          next1 = P1;
          p1red_next = 1'b1;
          time1_next = timer;
        end
        else next1 = WAIT1;
      end
      
      P1: begin
        if (timer == time1 + 10'h008) begin
          next1 = WAIT1;
          p1red_next = 1'b0;
        end
        else begin
          time1_next = p2gain? timer : time1;
          p1red_next = 1'b1;
          next1 = P1;
        end
      end
        
        endcase
      end
  
endmodule
