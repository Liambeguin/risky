.section .text
.globl main

.equ UPPER_IOMEM_BASE, 0x0400
.equ IO_LED_BASE, 0x04


main:
	# we're going to call wait so we have to save ra on the stack
	addi sp, sp, -4
	sw ra, 0(sp)

	lui gp, UPPER_IOMEM_BASE
.L0:
	li a0, 5
	sw a0, IO_LED_BASE(gp)
	call wait
	li a0, 10
	sw a0, IO_LED_BASE(gp)
	call wait
	j .L0
	lw ra, 0(sp)	# restore ra
	addi sp, sp, 4	# restore sp
	ret
