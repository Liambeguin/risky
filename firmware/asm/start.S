.section .text
.globl start

.equ STACK_SIZE, 0x400

start:
	li sp, STACK_SIZE
	call main
	ebreak
