.section .text
.globl main

main:
	li t0, 5
.L0:
	addi t0, t0, 1
	call wait
	j .L0
