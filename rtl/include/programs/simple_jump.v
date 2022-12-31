integer L0_ = 8;
integer L1_ = 20;

initial begin
	ASM_ADDI(x1, x0, 1);
	ASM_ADDI(x2, x0, 10);
	ASM_Label(L0_);
	ASM_ADDI(x1, x1, 1);
	ASM_BEQ(x1, x2, ASM_LabelRef(L1_));
	ASM_JAL(x0, ASM_LabelRef(L0_));
	ASM_Label(L1_);
	ASM_LW(x2, x1, 0);
	ASM_SW(x2, x1, 0);
	ASM_EBREAK();
	ASM_endASM();
	$display();
end
