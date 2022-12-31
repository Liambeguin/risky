BUILDDIR = builddir
PROG = include/programs/store_w.v

.PHONY: blinky-sim
blinky-sim: test/bench_iverilog.v rtl/soc_top.v
	@mkdir -p $(BUILDDIR)
	@iverilog \
		-I rtl \
		-o $(BUILDDIR)/blinky \
		-DBENCH \
		-DBOARD_FREQ=10 \
		-DPROGRAM=\"$(PROG)\" \
		$^
	@vvp -n $(BUILDDIR)/blinky
