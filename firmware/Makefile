CROSS_COMPILE = riscv64-linux-gnu-

AS = $(CROSS_COMPILE)as
ASFLAGS = -march=rv32i -mabi=ilp32 -mno-relax

LD = $(CROSS_COMPILE)ld
LDFLAGS = -T asm/bram.ld -m elf32lriscv -nostdlib -no-relax

%.o: %.S
	$(AS) $(ASFLAGS) -o $@ $^

# tool taken as is from site
# TODO: replace this with objcopy or something
tool/firmware_words: tool/firmware_words.cpp tool/femto_elf.c
	@g++ -DSTANDALONE_FEMTOELF $^ -o $@

RAM_SIZE = 6144
%.hex: %.elf
	@./tool/firmware_words $< -ram $(RAM_SIZE) -max_addr 65535 -out $@

clean:
	@rm -f /asm/*.o asm/*.hex asm/*.elf
	@rm -f asm/test000.bram.elf
	@rm -f tool/firmware_words


asm/test000.bram.elf: asm/start.o asm/wait.o asm/test000.o
	$(LD) $(LDFLAGS) -o $@ $^

asm/test000.bram.hex: tool/firmware_words asm/test000.bram.elf
