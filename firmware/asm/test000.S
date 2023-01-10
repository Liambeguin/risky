.section .text
.globl main

main:
	# Function Prologue
	addi sp, sp, -4
	sw ra, 0(sp)

	li t1, 0
	li t2, 10
.L0:
	addi t1, t1, 1
	call wait
	bne t1, t2, .L0

	# Function Epilogue
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
