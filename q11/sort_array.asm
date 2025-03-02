.globl main
.data
array:  .word 5, 1, 4, 2, 8   
size:   .word 5               
newline: .asciz "\n"          

.text
main:
    la t0, array   
    lw t1, size    

    li t2, 0       

outer_loop:
    addi t3, t1, -1    
    blt t2, t3, inner_loop_start
    j print_array  

inner_loop_start:
    li t4, 0  
    la t5, array  

inner_loop:
    sub t6, t1, t2      
    addi t6, t6, -1     
    blt t4, t6, compare_swap
    addi t2, t2, 1  
    j outer_loop    

compare_swap:
    lw t3, 0(t5)     
    lw t6, 4(t5)     
    bge t3, t6, no_swap  

    sw t6, 0(t5)     
    sw t3, 4(t5)     

no_swap:
    addi t5, t5, 4   
    addi t4, t4, 1   
    j inner_loop

print_array:
    la t0, array   
    li t2, 0       

print_loop:
    lw a0, 0(t0)   
    li a7, 1       
    ecall

    li a0, 32      
    li a7, 11
    ecall

    addi t0, t0, 4 
    addi t2, t2, 1 
    blt t2, t1, print_loop 

    li a7, 4
    la a0, newline
    ecall

    li a7, 10
    ecall