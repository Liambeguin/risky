.section .text
.globl main

main:
	li t1, 20
.L0:
	addi t1, t1, -1
	call wait
	bnez t1, .L0
	ret
