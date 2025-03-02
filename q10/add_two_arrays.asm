.globl main
.data
array1: .word 1, 2, 3, 4, 5  
array2: .word 6, 7, 8, 9, 10 
result: .space 20            
size:   .word 5              

.text
main:
    la t0, array1    
    la t1, array2    
    la t2, result    
    lw t3, size      

    li t4, 0         

loop:
    lw t5, 0(t0)     
    lw t6, 0(t1)     

    add t5, t5, t6   

    sw t5, 0(t2)     

    addi t0, t0, 4   
    addi t1, t1, 4   
    addi t2, t2, 4   

    addi t4, t4, 1	
    blt t4, t3, loop 

    la t2, result    
    li t4, 0         

print_loop:
    lw a0, 0(t2)     
    li a7, 1        
    ecall

    li a0, 32        
    li a7, 11
    ecall

    addi t2, t2, 4   
    addi t4, t4, 1   
    blt t4, t3, print_loop 

    li a7, 10
    ecall