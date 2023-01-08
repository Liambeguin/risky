BUILDDIR = builddir

TOPLEVEL ?= soc_top
TOOL ?= icarus

RTL_FILES = $(wildcard rtl/*.v)

FW ?= firmware/asm/test000.bram.elf
P ?= $(patsubst %.elf,%.hex,$(FW))

firmware/%:
	$(MAKE) -C firmware $(patsubst firmware/%,%,$@)


setup:
	@fusesoc init -y
	@fusesoc library add --sync-type local blinky .
	@fusesoc library add elf-loader https://github.com/fusesoc/elf-loader.git

simulate: $(FW)
	@fusesoc run \
		--target sim \
		--tool $(TOOL) \
		liambeguin:blinky:soc:0.1.0 \
		--elf_load $(FW)

clean:
	@$(MAKE) -C firmware clean
	@$(MAKE) -C test clean
	@rm -rf build/
	@rm -rf obj_dir/ builddir/
	@rm -rf test/__pycache__/ test/sim_build/
