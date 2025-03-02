.data
infix:  .asciz "a+b*c-d/e/f/g"  # Input infix expression
postfix: .space 50           # Buffer for postfix output
stack:   .space 50           # Stack for operators
size:  .word 13

.text
.globl main

main:
	la s6, infix       # Load address of infix expression
	la a1, postfix     # Load address of postfix buffer
	la a2, stack       # Load address of stack
	la t0, size
	lw a3, 0(t0)

	li t0, 0	# j = 0
	li t1, -1	# top = -1
	li t2, 0	# i = 0
	
for_loop:
	bge t2, a3, final_for_loop
	
	# infix[i]
	add t6, s6, t2
	lb t3, 0(t6) 	# t3 = c
	
	li t4, 'a'
    	# li t5, 'z'
   	bge t3, t4, print_operand
    	# ble t3, t5, print_operand
    	
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
	li a7, 11
	ecall
	j increment

final_for_loop:
	bgez t1, pop_stack_final
	
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
	

	bge s4, s5, pop_stack
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
	li a7, 11
	ecall

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
	li a7, 11
	ecall

	addi t1, t1, -1
	j final_for_loop
	

	
