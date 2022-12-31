integer slow_bit = 3;
integer L0_ = 8;
integer wait_ = 24;
integer L1_ = 32;

initial begin
	ASM_ADD(x10, x0, x0);
	ASM_ADDI(x12, x0, 5);
ASM_Label(L0_);
	ASM_ADDI(x10, x10, 1);
	ASM_JAL(x1, ASM_LabelRef(wait_)); // call(wait_)
	ASM_JAL(zero, ASM_LabelRef(L0_)); // jump(l0_)

	ASM_EBREAK(); // I keep it systematically here in case I change the program.

ASM_Label(wait_);
	ASM_ADDI(x11, x0, 1);
	ASM_SLLI(x11, x11, slow_bit);
ASM_Label(L1_);
	// ASM_ADDI(x11, x11, $signed(-1));
	ASM_ADDI(x11, x11, -1);
	ASM_ADDI(x11, x11, 0);
	// ASM_SUB(x11, x11, x12);
	ASM_BNE(x11, x0, ASM_LabelRef(L1_));
	ASM_JALR(zero, ra, 0);

	ASM_endASM();
	$display();
end
