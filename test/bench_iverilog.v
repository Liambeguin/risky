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

	reg [1023:0] elf_file;
	reg [31:0] mem_word;
	integer mem_words;
	integer i;

	initial begin
		CLK = 0;

		if ($test$plusargs("vcd")) begin
			$dumpfile("dump_soc_top.vcd");
			$dumpvars;
		end

		if ($test$plusargs("clear-ram")) begin
			$display("Clearing RAM...");
			for (i=0; i < RAM_SIZE; i++)
				bench.dut.RAM.MEM[i] = 32'h00000000;
		end

		if ($value$plusargs("elf_load=%s", elf_file)) begin
			$display("Loading %0s", elf_file);
			$elf_load_file(elf_file);

			mem_words = $elf_get_size / 4;
			$display("Loading %0d words", mem_words);
			for(i = 0; i < mem_words; i++)
				bench.dut.RAM.MEM[i] = $elf_read_32(i * 4);
		end else
			$display("NO elf");

		forever begin
			#1 CLK = ~CLK;
		end
	end
endmodule
