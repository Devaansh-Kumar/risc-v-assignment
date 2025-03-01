.data
result: .word 1 # Placeholder for the result
enter: .string "Enter n: "

.text
.globl main

main:
    # Get user input
    li a0, 1
    la a1, enter
    li a2, 9
    li a7, 64
    ecall
    li a7, 5
    ecall
    
    # Load numbers into registers
    mv a1, a0    # Load number into a1
    li a2, 1     # Initialize multiplier to 1
    li a3, 1     # Initialize factorial result to 1

factorial_loop:
    bgt a2, a1, factorial_done  # If multiplier > num, factorial is complete
    mv a4, a3       		# Copy current result
    mv a5, a2       		# Copy multiplier
    jal ra, multiply_proc  	# Call multiplication procedure
    mv a3, a0       		# Store multiplication result
    addi a2, a2, 1 		# Increment multiplier
    j factorial_loop  		# Repeat loop

factorial_done:
    # Print result
    li a7, 1
    ecall

    # Exit the program
    li a0, 0
    li a7, 93
    ecall

# Multiplication procedure
multiply_proc:
    li a6, 0       		# a6 will store the result (initialize to 0)

multiply_loop:
    beqz a5, multiply_done  	# If multiplier is 0, exit loop
    add a6, a6, a4  		# Add multiplicand to result
    addi a5, a5, -1 		# Decrement multiplier
    j multiply_loop 		# Repeat

multiply_done:
    mv a0, a6      		# Store result in a0 (return value)
    ret
