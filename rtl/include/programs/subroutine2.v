integer slow_bit = 3;
integer L0_   = 8;
integer wait_ = 28;
integer L1_   = 36;

initial begin
	ASM_LI(a0, 0);
	ASM_ADDI(a2, x0, 5);
ASM_Label(L0_);
	ASM_ADDI(a0, a0, 1);
	ASM_CALL(ASM_LabelRef(wait_));
	ASM_J(ASM_LabelRef(L0_));

	ASM_EBREAK();

ASM_Label(wait_);
	ASM_LI(a1, 1);
	ASM_SLLI(a1, a1, slow_bit);
ASM_Label(L1_);
	// ASM_ADDI(a1, a1, -1);
	ASM_SUB(a1, a1, a2);
	ASM_BNEZ(a1, ASM_LabelRef(L1_));
	ASM_RET();

	ASM_endASM();
	$display();
end
