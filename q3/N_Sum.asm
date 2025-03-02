.globl main

.data
N:
    .word 10

.text

main:
    la t0, N       
    lw t0, (t0)    
    li t1, 0       
    li t2, 1       

loop:
    add t1, t1, t2 
    addi t2, t2, 1 
    ble t2, t0, loop 

    add a0, zero, t1
    li a7, 1       
    ecall

    li a7, 10
    ecall