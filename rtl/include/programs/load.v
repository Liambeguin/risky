integer slow_bit = 3;
integer L0_   = 8;
integer wait_ = 32;
integer L1_   = 40;

initial begin
	ASM_LI(s0, 0);
	ASM_LI(s1, 16);
ASM_Label(L0_);
	ASM_LB(a0, s0, 400); // LEDs are plugged on a0 (=x10)
	ASM_CALL(ASM_LabelRef(wait_));
	ASM_ADDI(s0, s0, 1);
	ASM_BNE(s0, s1, ASM_LabelRef(L0_));
	ASM_EBREAK();

ASM_Label(wait_);
	ASM_LI(t0, 1);
	ASM_SLLI(t0, t0, slow_bit);
ASM_Label(L1_);
	ASM_ADDI(t0, t0, -1);
	ASM_BNEZ(t0, ASM_LabelRef(L1_));
	ASM_RET();

ASM_endASM();
	$display();

	// Note: index 100 (word address)
	//     corresponds to
	// address 400 (byte address)
	MEM[100] = {8'h4, 8'h3, 8'h2, 8'h1};
	MEM[101] = {8'h8, 8'h7, 8'h6, 8'h5};
	MEM[102] = {8'hc, 8'hb, 8'ha, 8'h9};
	MEM[103] = {8'hff, 8'hf, 8'he, 8'hd};
end
