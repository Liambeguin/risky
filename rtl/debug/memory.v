integer i;

initial begin
	$display("\t==================================");
	for (i = 0; i < 10; i++) $display("%d\t%d\t0x%x", i, i << 2, MEM[i]);
	$display("\t...");
	for (i = 100; i < 110; i++) $display("%d\t%d\t0x%x", i, i << 2, MEM[i]);
	$display("\t==================================");
	$display();
end
