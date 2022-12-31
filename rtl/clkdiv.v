module clkdiv (
	input CLK,
	output clk);

	parameter DIVIDER = 1;

	reg [DIVIDER:0] slow_clk = 0;

	always @(posedge CLK) begin
		slow_clk <= slow_clk + 1;
	end

	assign clk = slow_clk[DIVIDER];

endmodule
