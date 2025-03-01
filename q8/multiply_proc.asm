# program for multiplying two numbers
.data
num1: .word 7   # First number
num2: .word 5   # Second number
result: .word 0 # Placeholder for the result

.text
.globl main

main:
    # Load numbers into registers
    la a0, num1  # Load address of num1
    lw a1, 0(a0) # Load num1 into a1
    la a0, num2  # Load address of num2
    lw a2, 0(a0) # Load num2 into a2

    # Call the multiply procedure
    jal ra, multiply_proc

    # Store result in memory
    la a0, result
    sw a0, 0(a0)

    # Exit the program
    li a0, 0   # Set return value to 0
    li a7, 93  # Correct exit syscall for RV64I
    ecall

# Multiplication procedure using only RV64I instructions
multiply_proc:
    li a3, 0       # a3 will store the result (initialize to 0)
    li a4, 0       # Counter

loop:
    beqz a2, done  # If multiplier is 0, exit loop
    add a3, a3, a1 # Add multiplicand to result
    addi a2, a2, -1 # Decrement multiplier
    j loop         # Repeat

done:
    mv a0, a3      # Store result in a0 (return value)
    li a7, 1
    ecall
    ret
