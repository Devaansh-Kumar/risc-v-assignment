.globl main

.data

infix:    .string "a+b*c"   # Change this for different expressions

newline:  .string "\n"

operator_stack: .space 10   # Stack for operators



.text

main:

    la t0, infix      # Pointer to infix expression

    la t1, operator_stack  # Pointer to operator stack

    li s1, 0          # Stack index



process_input:

    lbu t3, 0(t0)     # Load current character

    beqz t3, process_stack  # If end of string, process remaining stack



    # Check if character is an operand (a-z)

    li t4, 'a'

    li t5, 'z'

    bgeu t3, t4, check_operator

    bleu t3, t5, print_operand



check_operator:

    li t4, '+'

    li t5, '-'

    li s2, '*'

    li s3, '/'



    beq t3, t4, handle_plus_minus

    beq t3, t5, handle_plus_minus

    beq t3, s2, handle_mul_div

    beq t3, s3, handle_mul_div

    j loop_continue



print_operand:

    # Print operand immediately

    li a7, 11

    mv a0, t3

    ecall



    # Print space

    li a7, 11

    li a0, ' '

    ecall



    j loop_continue



handle_plus_minus:

    beq s1, zero, push_operator  # If stack is empty, push operator



pop_lower_precedence:

    lb t4, -1(t1)   # Load top of stack

    li t5, '*'      

    li s2, '/'      



    beq t4, t5, pop_operator

    beq t4, s2, pop_operator

    j push_operator



handle_mul_div:

    beq s1, zero, push_operator

    lb t4, -1(t1)       

    li s2, '+'

    li s3, '-'



    beq t4, s2, push_operator

    beq t4, s3, push_operator

    j pop_operator



push_operator:

    sb t3, 0(t1)   # Push operator onto stack

    addi t1, t1, 1

    addi s1, s1, 1

    j loop_continue



pop_operator:

    lb t4, -1(t1)  # Load top of stack



    # Print the operator

    li a7, 11

    mv a0, t4

    ecall



    # Print space

    li a7, 11

    li a0, ' '

    ecall



    addi t1, t1, -1  # Pop from stack

    addi s1, s1, -1

    j pop_lower_precedence



loop_continue:

    addi t0, t0, 1  # Move to next character

    j process_input



process_stack:

    beq s1, zero, print_newline

    call pop_operator

    j process_stack



print_newline:

    li a7, 4

    la a0, newline

    ecall



    # Exit program

    li a7, 10

    ecall
