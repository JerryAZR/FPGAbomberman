module   Character 
			(  input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY, X_Reset, Y_Reset,       // Current pixel coordinates
			   input [7:0]	 move,
			   input [9:0]	 Step,
			   input upID, downID, leftID, rightID,
               output logic  is_Char,             // Whether current pixel belongs to Char or background
			   output logic [9:0] Char_X_Pos, Char_Y_Pos,
			   output logic dir
              );

	initial begin
		Char_X_Pos = 10'd32;
		Char_Y_Pos = 10'd32;
	end
	
    parameter [9:0] Char_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Char_X_Max = 10'd479;     // Rightmost point on the X axis
    parameter [9:0] Char_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Char_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Char_Size = 10'd31;        // Char size

    logic [9:0] Char_X_Motion, Char_Y_Motion;
    logic [9:0] Char_X_Pos_in, Char_X_Motion_in, Char_Y_Pos_in, Char_Y_Motion_in;
	logic dir_next;
	logic [4:0] Char_X_Map_Pos, Char_Y_Map_Pos;
	
	assign Char_X_Map_Pos = {(Char_X_Pos[9:5] + {{4{1'b0}},Char_X_Pos[4]})};
	assign Char_Y_Map_Pos = {(Char_Y_Pos[9:5] + {{4{1'b0}},Char_Y_Pos[4]})};

    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Char_X_Pos <= X_Reset;
            Char_Y_Pos <= Y_Reset;
            Char_X_Motion <= 10'd0;
            Char_Y_Motion <= 10'd0;
        end
        else
        begin
            Char_X_Pos <= Char_X_Pos_in;
            Char_Y_Pos <= Char_Y_Pos_in;
            Char_X_Motion <= Char_X_Motion_in;
            Char_Y_Motion <= Char_Y_Motion_in;
			dir <= dir_next;
        end
    end
	
    always_comb
    begin
        // By default, keep motion and position unchanged
        Char_X_Pos_in = Char_X_Pos;
        Char_Y_Pos_in = Char_Y_Pos;
        Char_X_Motion_in = Char_X_Motion;
        Char_Y_Motion_in = Char_Y_Motion;
		dir_next = dir;

        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
			
			unique case (move)
				8'd79, 8'd07 : begin // right
					if( Char_X_Pos + Char_Size > Char_X_Max || rightID == 1'b0)  // Char is at the rignt edge
						Char_X_Motion_in = 10'd0; 
					else begin
						Char_X_Motion_in = Step;
						Char_Y_Pos_in = {Char_Y_Map_Pos, {5{1'b0}}};
					end
					Char_Y_Motion_in = 10'h000; 
					dir_next = 1'b1;
					Char_X_Pos_in = Char_X_Pos + Char_X_Motion_in;
					
				end 
				8'd80, 8'd04 : begin //left
					if ( Char_X_Pos < Char_X_Min || leftID == 1'b0)  // Char is at the left edge
						Char_X_Motion_in = 10'd0;
					else begin
						Char_X_Motion_in = (~(Step) + 1'b1); 
						Char_Y_Pos_in = {Char_Y_Map_Pos, {5{1'b0}}};
					end
					Char_Y_Motion_in = 10'h000; 
					dir_next = 1'b0;
					Char_X_Pos_in = Char_X_Pos + Char_X_Motion_in;
					
				end 
				8'd81, 8'd22 : begin // down
					Char_X_Motion_in = 10'h000; 
					if( Char_Y_Pos + Char_Size > Char_Y_Max || downID == 1'b0)  // Char is at the bottom edge
						Char_Y_Motion_in = 10'd0; 
					else begin
						Char_Y_Motion_in = Step;
						Char_X_Pos_in = {Char_X_Map_Pos, {5{1'b0}}};	
					end
					Char_Y_Pos_in = Char_Y_Pos + Char_Y_Motion_in;
					
				end 
				8'd82, 8'd26 : begin // up
					Char_X_Motion_in = 10'h000; 
					if( Char_Y_Pos < Char_Y_Min || upID == 1'b0) 
						Char_Y_Motion_in = 10'd0;
					else begin
						Char_Y_Motion_in = (~(Step) + 1'b1); 
						Char_X_Pos_in = {Char_X_Map_Pos, {5{1'b0}}};
					end
					Char_Y_Pos_in = Char_Y_Pos + Char_Y_Motion_in;
					
				end 
				default : begin
					Char_X_Motion_in = 10'd0;
					Char_Y_Motion_in = 10'd0;
					Char_X_Pos_in = Char_X_Pos;
					Char_Y_Pos_in = Char_Y_Pos;
				end
				
			endcase            
        end
    end

    int Size;

    assign Size = Char_Size;
    always_comb begin
//        if ( DrawX >= Char_X_Pos && DrawY >= Char_Y_Pos && DrawX <= Char_X_Pos+Size && DrawY <= Char_Y_Pos+Size )
		if(DrawX - Char_X_Pos <= Size && DrawY - Char_Y_Pos <= Size)
            is_Char = 1'b1;
        else
            is_Char = 1'b0;
    end

endmodule
