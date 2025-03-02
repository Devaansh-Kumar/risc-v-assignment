.globl main
.text
main:
	li a7,5
	ecall
	
	addi t0, a0, 1
	mul a0, t0, a0
	srai a0, a0, 1
	
	li a7, 1
	ecall
	
	li a7, 10
	ecall 
