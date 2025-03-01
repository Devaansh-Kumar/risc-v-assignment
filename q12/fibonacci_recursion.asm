.data
prompt: .asciz "Enter the number of Fibonacci numbers to print: "
newline: .asciz "\n"

.text
.globl main

main:
    # Print prompt message
    la a0, prompt
    li a7, 4
    ecall
    
    # Read integer input (N)
    li a7, 5
    ecall
    mv s0, a0    # Store N in s0
    
    # Initialize loop index
    li s1, 0      # i = 0

fib_loop:
    bge s1, s0, exit   # If i >= N, exit loop
    
    mv a0, s1    # Pass i to fib function
    call fib     # Call recursive Fibonacci function

    # Print the result
    li a7, 1
    ecall

    # Print newline
    li a7, 4
    la a0, newline
    ecall

    # Increment index
    addi s1, s1, 1
    j fib_loop

exit:
    li a0, 0
    li a7, 93
    ecall

# Recursive Fibonacci Function
fib:
    addi sp, sp, -16   # Allocate stack space
    sw ra, 0(sp)       # Save return address
    sw s1, 4(sp)       # Save s1 (for fib(n-1))
    sw s2, 8(sp)       # Save s2 (for fib(n-2))
    sw a0, 12(sp)      # Save original input n

    # Base case: fib(0) = 0
    beqz a0, fib_base0

    # Base case: fib(1) = 1
    li t0, 1
    beq a0, t0, fib_base1

    # Recursive case: fib(n) = fib(n-1) + fib(n-2)
    addi a0, a0, -1   # Compute fib(n-1)
    call fib
    mv s1, a0         # Store fib(n-1) in s1

    lw a0, 12(sp)     # Restore original n before computing fib(n-2)
    addi a0, a0, -2   # Compute fib(n-2)
    call fib
    mv s2, a0         # Store fib(n-2) in s2

    add a0, s1, s2    # fib(n) = fib(n-1) + fib(n-2)

fib_return:
    lw ra, 0(sp)      # Restore return address
    lw s1, 4(sp)      # Restore s1
    lw s2, 8(sp)      # Restore s2
    addi sp, sp, 16   # Restore stack space
    ret

fib_base0:
    li a0, 0
    j fib_return

fib_base1:
    li a0, 1
    j fib_return
