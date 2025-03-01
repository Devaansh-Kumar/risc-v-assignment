.data
num1: .word 36  # First number
num2: .word 24  # Second number

.text
.globl main

main:
    # Load the numbers into registers
    la a0, num1    # Load address of num1
    lw a1, 0(a0)   # Load num1 into a1
    la a0, num2    # Load address of num2
    lw a2, 0(a0)   # Load num2 into a2

    # Call the GCD function
    jal ra, gcd

    # Exit the program
    li a0, 0
    li a7, 93
    ecall

# GCD function using Euclidean algorithm
gcd:
    loop:
        beqz a2, done   # If b == 0, GCD is found
        rem a3, a1, a2  # a3 = a1 % a2
        mv a1, a2       # a1 = a2
        mv a2, a3       # a2 = a3
        j loop          # Repeat

done:
    mv a0, a1          # Store GCD in a0 (return value)
    li a7, 1
    ecall
    ret
