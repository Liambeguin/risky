// Inspired by: https://github.com/BrunoLevy/learn-fpga (from blinker to riscv)

`default_nettype none

module soc_top #(
	parameter XLEN = 32,
	parameter RAM_SIZE = 'h600
	)(
	input CLK,
	output reg [3:0] LEDS);

	wire clk;
	wire mem_rstrb;
	wire [XLEN-1:0] mem_addr;
	wire [XLEN-1:0] mem_rdata;
	wire [XLEN-1:0] mem_wdata;
	wire [3:0] mem_wmask;

	wire is_iomem = mem_addr[22]; // anything under 0x0040_0000 is iomem
	wire is_ram = !is_iomem;
	wire mem_wstrb = |mem_wmask;

	memory #(
		.XLEN(XLEN),
		.depth(RAM_SIZE)
	) RAM (
		.clk(clk),
		.mem_addr(mem_addr),
		.mem_rdata(mem_rdata),
		.mem_rstrb(mem_rstrb), // rstrb is Read Strobe
		.mem_wdata(mem_wdata),
		.mem_wmask({4{is_ram}} & mem_wmask)
	);

	processor #(
		.XLEN(XLEN)
	) blinky (
		.clk(clk),
		.mem_addr(mem_addr),
		.mem_rdata(mem_rdata),
		.mem_rstrb(mem_rstrb), // rstrb is Read Strobe
		.mem_wdata(mem_wdata),
		.mem_wmask(mem_wmask)
	);

	clkdiv #(
		.DIVIDER(13) // divide clk by 2^n
	) div_inclk(
		.CLK(CLK),
		.clk(clk)
	);

	always @(posedge clk) begin
		if (is_iomem & mem_wstrb) begin
			case (mem_addr[21:0])
			'h4: begin
				LEDS <= mem_wdata;
			end
			endcase
		end
	end
endmodule
