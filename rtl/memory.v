`default_nettype none

`ifndef PROGRAM
	`define PROGRAM "include/programs/simple_addi.v"
`endif

module memory(
	input                 clk,
	input      [XLEN-1:0] mem_addr,
	input                 mem_rstrb,
	output reg [XLEN-1:0] mem_rdata,
	input      [XLEN-1:0] mem_wdata,
	input      [3:0]      mem_wmask);

	parameter XLEN = 32;

	reg[XLEN-1:0] MEM[0:255]; // This has to be called MEM to be used with riscv_assembly.v
	`include "include/riscv_assembly.v"

	initial begin
		$display("\t==================================");
		$display("\tLoading \"%s\"", `PROGRAM);
		$display("\t==================================");
	end

	`include `PROGRAM
	`include "debug/memory.v"

	wire [XLEN-1:0] word_addr = {2'b0, mem_addr[31:2]};

	always @(posedge clk) begin
		if (mem_rstrb) mem_rdata <= MEM[word_addr];
		if (mem_wmask[0]) MEM[word_addr][ 7: 0] <= mem_wdata[ 7: 0];
		if (mem_wmask[1]) MEM[word_addr][15: 8] <= mem_wdata[15: 8];
		if (mem_wmask[2]) MEM[word_addr][23:16] <= mem_wdata[23:16];
		if (mem_wmask[3]) MEM[word_addr][31:24] <= mem_wdata[31:24];
	end
endmodule
