.section .text
.globl wait

wait:
	li t0, 1
	slli t0, t0, 3

.Lwait0:
	addi t0, t0, -1
	bnez t0, .Lwait0
	ret
