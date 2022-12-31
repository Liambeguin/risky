BUILDDIR = builddir
PROG = include/programs/store_w.v

TOPLEVEL = soc_top


SIM ?= icarus
blinky-sim: blinky-sim-$(SIM)

.PHONY: blinky-sim
blinky-build-icarus: test/bench_iverilog.v rtl/$(TOPLEVEL).v
	@mkdir -p $(BUILDDIR)
	@iverilog \
		-I rtl \
		-o $(BUILDDIR)/blinky \
		-DBENCH \
		-DBOARD_FREQ=10 \
		-DPROGRAM=\"$(PROG)\" \
		$^

blinky-sim-icarus: blinky-build-icarus
	@vvp -n $(BUILDDIR)/blinky


blinky-build-verilator: test/sim_main.cpp rtl/$(TOPLEVEL).v
	@verilator \
		-DBENCH \
		-DBOARD_FREQ=12 \
		-Wno-fatal \
		--top-module $(TOPLEVEL) \
		--cc --exe --build --relative-includes \
		$^

blinky-sim-verilator: blinky-build-verilator
	@./obj_dir/V$(TOPLEVEL)
