initial begin

	ASM_LI(s0, 0);		// write 0x00000000 to s0 (x8)
	ASM_LI(a0, 'hffff);	// write 0x0000ffff to a0 (x10)
	ASM_LI(s1, 'hdeadbeef);	// write 0xdeadbeef to s1 (x9)
	// ASM_SW(x8, s1, 404);	// store $s1 at addr $s0 + 404
	ASM_SW(s1, s0, 404);	// store $s1 at addr $s0 + 404
	ASM_LI(a0, 0);
	ASM_LW(a0, s0, 404);	// load addr $s0 + 404 to a0 (x10)
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
