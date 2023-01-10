.section .text
.globl main

.equ UPPER_IOMEM_BASE, 0x0400
.equ IO_LED_BASE, 0x04
.equ IO_UART_BASE, 0x08

putc:
	sw a0, IO_UART_BASE(gp)
	ret

putstring:
	addi sp, sp, -4
	sw ra, 0(sp)

	mv t2, a0	# copy a0 into t2
.puts_char:
	lbu a0, 0(t2)
	beqz a0, .puts_out
	call putc
	addi t2, t2, 1
	j .puts_char

.puts_out:
	lw ra, 0(sp)	# restore ra
	addi sp, sp, 4	# restore sp
	ret

main:
	# we're going to call wait so we have to save ra on the stack
	addi sp, sp, -4
	sw ra, 0(sp)

	lui gp, UPPER_IOMEM_BASE
	la a0, hellow
	call putstring

	lw ra, 0(sp)
	addi sp, sp, 4
	ret

.section: .data
hellow:
	.asciz "Hello world!\n"
