CROSS_COMPILE = riscv64-linux-gnu-

AS = $(CROSS_COMPILE)as
ASFLAGS = -march=rv32i -mabi=ilp32 -mno-relax

LD = $(CROSS_COMPILE)ld
LDFLAGS = -T firmware/asm/bram.ld -m elf32lriscv -nostdlib -no-relax

TOPLEVEL ?= soc_top
TOOL ?= icarus

RTL_FILES = $(wildcard rtl/*.v)

FW ?= firmware/asm/test000.bram.elf


setup:
	@fusesoc init -y
	@fusesoc library add --sync-type local blinky .
	@fusesoc library add elf-loader https://github.com/fusesoc/elf-loader.git


%.o: %.S
	$(AS) $(ASFLAGS) -o $@ $^

firmware/asm/test000.bram.elf: firmware/asm/start.o firmware/asm/wait.o firmware/asm/test000.o
	$(LD) $(LDFLAGS) -o $@ $^


simulate: $(FW)
	@fusesoc run \
		--target sim \
		--tool $(TOOL) \
		liambeguin:blinky:soc:0.1.0 \
		--elf_load $(FW)

disassemble: $(FW)
	riscv64-linux-gnu-objdump -d $(FW)


clean:
	@rm -f firmware/asm/*.o firmware/asm/*.elf
	@rm -rf build/
	@rm -rf obj_dir/
	@rm -rf test/__pycache__/ test/sim_build/
