initial begin
	ASM_LI(s0, 0);
	ASM_LI(s1, 16);
	ASM_LH(a0, s0, 400);
	ASM_LB(a0, s0, 400);
	ASM_LB(a0, s0, 401);
	ASM_EBREAK();

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
