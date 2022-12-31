// Inspired by: https://github.com/BrunoLevy/learn-fpga (from blinker to riscv)

`default_nettype none
`include "clkdiv.v"
`include "memory.v"
`include "processor.v"

module soc_top (
	input CLK);

	parameter XLEN = 32;

	wire clk;
	wire mem_rstrb;
	wire [XLEN-1:0] mem_addr;
	wire [XLEN-1:0] mem_rdata;
	wire [XLEN-1:0] mem_wdata;
	wire [3:0] mem_wmask;

	memory #(
		.XLEN(XLEN)
	) RAM (
		.clk(clk),
		.mem_addr(mem_addr),
		.mem_rdata(mem_rdata),
		.mem_rstrb(mem_rstrb),
		.mem_wdata(mem_wdata),
		.mem_wmask(mem_wmask)
	);

	processor #(
		.XLEN(XLEN)
	) blinky (
		.clk(clk),
		.mem_addr(mem_addr),
		.mem_rdata(mem_rdata),
		.mem_rstrb(mem_rstrb),
		.mem_wdata(mem_wdata),
		.mem_wmask(mem_wmask)
	);

	clkdiv #(
		.DIVIDER(13) // divide clk by 2^n
	) div_inclk(
		.CLK(CLK),
		.clk(clk)
	);
endmodule
