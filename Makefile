BUILDDIR = builddir

TOPLEVEL ?= soc_top
SIM ?= icarus

RTL_FILES = $(wildcard rtl/*.v)

P ?= firmware/asm/test000.bram.hex

firmware/%:
	$(MAKE) -C firmware $(patsubst firmware/%,%,$@)


.PHONY: blinky-sim
blinky-sim: blinky-sim-$(SIM)

ICARUS_COMPILE_ARGS = \
	-DBENCH \
	-DPROGRAM=\"$(realpath $P)\" \
	-grelative-include

blinky-build-icarus: test/bench_iverilog.v $(RTL_FILES) $(P)
	@mkdir -p $(BUILDDIR)
	@iverilog \
		$(ICARUS_COMPILE_ARGS) \
		-o $(BUILDDIR)/blinky \
		test/bench_iverilog.v \
		$(RTL_FILES)

blinky-sim-icarus: blinky-build-icarus
	@vvp -n $(BUILDDIR)/blinky


VERILATOR_COMPILER_ARGS = \
	-DBENCH \
	-DPROGRAM=\"$(realpath $P)\" \
	--relative-includes \
	-Wno-fatal \
	--top-module $(TOPLEVEL) \
	--cc --exe --build

blinky-build-verilator: test/verilator/tb.cpp $(RTL_FILES) $(P)
	@verilator \
		$(VERILATOR_COMPILER_ARGS) \
		test/sim_main.cpp \
		$(RTL_FILES)

blinky-sim-verilator: blinky-build-verilator
	@./obj_dir/V$(TOPLEVEL)


.PHONY: test
test: $(P) $(RTL_FILES)
ifeq ($(SIM), verilator)
	$(error Verilator unsupported with cocotb)
else
	@SIM=$(SIM) \
	    TOPLEVEL=$(TOPLEVEL) \
	    COMPILE_ARGS='$(ICARUS_COMPILE_ARGS)' \
	    $(MAKE) -C test/ all
endif

