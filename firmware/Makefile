CROSS_COMPILE = riscv64-linux-gnu-

AS = $(CROSS_COMPILE)as
ASFLAGS = -march=rv32i -mabi=ilp32 -mno-relax

LD = $(CROSS_COMPILE)ld
LDFLAGS = -T asm/bram.ld -m elf32lriscv -nostdlib -no-relax


%.o: %.S
	$(AS) $(ASFLAGS) -o $@ $^


asm/test000.bram.elf: asm/start.o asm/wait.o asm/test000.o
	$(LD) $(LDFLAGS) -o $@ $^

asm/test_iomem.bram.elf: asm/start.o asm/wait.o asm/test_iomem.o
	$(LD) $(LDFLAGS) -o $@ $^


clean:
	@rm -f /asm/*.o asm/*.hex asm/*.elf
	@rm -f tool/firmware_words
