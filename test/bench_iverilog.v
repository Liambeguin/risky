`timescale 1ns/1ns

module bench#(
	parameter RAM_SIZE = 'h600
	)();

	reg CLK;

	soc_top #(
		.XLEN(32),
		.RAM_SIZE(RAM_SIZE)
	) dut (
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
