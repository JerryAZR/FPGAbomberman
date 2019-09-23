module timer_64Hz (
	input logic Clk, slow_clk,
	output logic [11:0] timer
);

	logic slow_clk_delayed, slow_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        slow_clk_delayed <= slow_clk;
        slow_clk_rising_edge <= (slow_clk == 1'b1) && (slow_clk_delayed == 1'b0);
    end

	always_ff @(posedge Clk) begin
		timer <= timer + {11'h000, slow_clk_rising_edge};
	end

endmodule
