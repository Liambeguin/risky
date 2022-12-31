`timescale 1ns/1ns

module bench();
	reg CLK;

	soc_top #(
		.XLEN(32)
	) uut (
		.CLK(CLK)
	);

	reg[32:0] prev_LEDS = 0;

	initial begin
		CLK = 0;

		forever begin
			#1 CLK = ~CLK;
		end
	end
endmodule
