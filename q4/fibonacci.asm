.data
newline: .string "\n"
prompt: .string "Enter n(>3): "
series:	.string "Fibonacci series is: "

.text
main:
	# Print prompt message
	la a0, prompt
	li a7, 4
	ecall

	# Read integer input
	li a7, 5
	ecall
	
	mv t4, a0
	addi t4, t4, -2
	
	# Print series
	la a0, series
	li a7, 4
	ecall
	
	# Initialize registers
	li t0, 0	# i = 0
	li t1, 0	# first number
	li t2, 1	# second number
	
	# Print the first 2 numbers
	mv a0, t1
	li a7, 1
	ecall
	la a0, newline
	li a7, 4
	ecall
	mv a0, t2
	li a7, 1
	ecall
	la a0, newline
	li a7, 4
	ecall
	
	mv t3, a0

fib_loop:
	bge t0, t4, exit 	# If i >= n, exit loop
	add t3, t2, t1		# third = second + first
	mv t1, t2			# first = second
	mv t2, t3			# second = third
	
	# Print ith fibonacci number
	mv a0, t3
	li a7, 1
	ecall
	la a0, newline
	li a7, 4
	ecall
	
	# Increment index
	addi t0, t0, 1
	j fib_loop

exit:
	li a0, 0
	li a7, 93
	ecall
