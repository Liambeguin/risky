initial begin
	ASM_ADDI(x1, x0, 1);
	ASM_ADDI(x1, x0, -1);

	// ASM_JAL(x1, -1);
	// ASM_JALR(x1, x2, -5);

	ASM_EBREAK();
	ASM_endASM();
	$display();
end
