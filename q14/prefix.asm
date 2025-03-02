.data
infix:  .asciz "a+b/c*d*e-f"  # Input infix expression
postfix: .space 50           # Buffer for postfix output
stack:   .space 50           # Stack for operators
size:  .word 11

.text
.globl main	
main:
   	# Now we reverse the string using two pointers
    	la      a1, infix              # a1 = start address of the string
    	la t0, size
    	lw t0, 0(t0)
    	addi t0, t0, -1
    	add     a2, a1, t0           # a2 = end address of the string (length-1)

reverse_loop:
    	lb      t1, 0(a1)            # Load byte from the start (a1)
    	lb      t2, 0(a2)            # Load byte from the end (a2)
    	sb      t2, 0(a1)            # Store byte from end to start
    	sb      t1, 0(a2)            # Store byte from start to end

    	addi    a1, a1, 1            # Increment start pointer
    	addi    a2, a2, -1           # Decrement end pointer
	
    	blt     a1, a2, reverse_loop # Repeat until pointers cross

the_real_main:
	la s6, infix       # Load address of infix expression
	la a1, postfix     # Load address of postfix buffer
	la a2, stack       # Load address of stack
	la t0, size
	lw a3, 0(t0)

	li t0, 0	# j = 0
	li t1, -1	# top = -1
	li t2, 0	# i = 0
	li s10, 0
	
for_loop:
	bge t2, a3, final_for_loop
	
	# infix[i]
	add t6, s6, t2
	lb t3, 0(t6) 	# t3 = c
	
	li t4, 'a'
   	bge t3, t4, print_operand
    	
while_condition:
	# if top != -1
	li t6, -1
	bne t1, t6, precedence	# stack not empty
	
	# stack[++top]
	addi t1, t1, 1
	add t6, t1, a2
	
	# stack[++top] = c
	sb t3, 0(t6)
	
increment:
	addi t2, t2, 1	# i++
	j for_loop	

print_operand:
	mv a0, t3
	add s11 , a1, s10
	addi s10,s10,1
	sb a0, (s11)
	j increment

final_for_loop:
	bgez t1, pop_stack_final
	
	bgez s10, final_reverse_print	

	li a7, 10
	ecall

# s7 holds precedence
# s6 holds infix address
precedence:
	# stack[top]
	add t6, t1, a2
	lb a0, 0(t6)
	jal ra, get_precedence
	mv s4, s7

	# stack[c]
	mv a0, t3
	jal ra, get_precedence
	mv s5, s7

	bgt s4, s5, pop_stack
	j push_stack

get_precedence:
	li s1, '+'
	li s2, '-'
	beq s1, a0, return_0
	beq s2, a0, return_0
	li s1, '*'
	li s2, '/'
	beq s1, a0, return_1
	beq s2, a0, return_1

pop_stack:
	#t6 has the stack top address
	la t0, stack
	add t6, t0, t1

	lb a0,(t6) # s1 = top of stack
	
	add s11 , a1, s10
	addi s10, s10, 1
	sb a0, (s11)

	addi t1, t1, -1
	j while_condition

push_stack:
	addi t1, t1, 1

	la t0, stack
	add t6, t0, t1

	sb t3, 0(t6)
	j increment

return_0:
	li s7, 0
	jalr ra
	
return_1:
	li s7, 1
	jalr ra

pop_stack_final:
	la t0, stack
	add t6, t0, t1

	lb a0,(t6) # s1 = top of stack
	
	add s11 , a1, s10
	addi s10,s10,1
	sb a0, (s11)

	addi t1, t1, -1
	j final_for_loop
	
final_reverse_print:
	add s11, a1, s10
	lb a0, (s11)
	addi s10, s10, -1
	
	li a7, 11
	ecall
	
	j final_for_loop