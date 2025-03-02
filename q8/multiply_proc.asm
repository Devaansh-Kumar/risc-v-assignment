.data
prompt: .string "Enter num: "
answer:	.string "Product is: "
result: .word  0     # Store the result

.text
.globl main

main:
    # Print prompt message
    la a0, prompt
    li a7, 4
    ecall

    # Read integer input
    li a7, 5
    ecall
    mv s0, a0
    
    # Print prompt message
    la a0, prompt
    li a7, 4
    ecall

    # Read integer input
    li a7, 5
    ecall
    mv s1, a0

    mv a0, s0
    mv a1, s1

    # Call multiply_proc
    call multiply_proc

    # Store the result in memory
    la t1, result
    sw a0, 0(t1)
    
    # Print answer
    la a0, answer
    li a7, 4
    ecall
    lw a0, 0(t1)
    li a7, 1
    ecall

    # Exit the program
    li a7, 10
    ecall

multiply_proc:
    # a0 = num1, a1 = num2
    li a2, 0      # Result initialized to 0

loop:
    andi t0, a1, 1      # Check if LSB of a1 is 1
    beqz t0, skip_add   # If LSB is 0, skip addition
    add a2, a2, a0      # Add num1 to result

skip_add:
    slli a0, a0, 1      # Left shift num1 (multiply by 2)
    srli a1, a1, 1      # Right shift num2 (divide by 2)
    bnez a1, loop       # Repeat while num2 is not 0

    mv a0, a2           # Move result to a0 (return value)
    ret                 # Return to caller