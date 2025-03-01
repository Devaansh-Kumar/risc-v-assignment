.data
hello: .string "Hello World!"

.text
.globl main
main:	
	la a0, hello
	li a7, 4
	ecall
	
	li a0, 0
	li a7, 93
	ecall
