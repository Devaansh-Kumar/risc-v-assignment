.globl main, print_int

.data
buffer: 
	.space 3   # Space for 2 digits + NULL terminator

.text
main:
    li a7, 5 
    ecall
    
    mv t0, a0      

    li t1, 0       
    li t2, 1       

loop:
    add t1, t1, t2 
    addi t2, t2, 1 
    ble t2, t0, loop 

    mv a0, t1      
    jal ra, print_int

    mv a0, a1      
    li a7, 4       
    ecall

    li a7, 10
    ecall


print_int:
    li t1, 10         
    div t2, a0, t1    
    rem t3, a0, t1    

    addi t2, t2, 48   
    addi t3, t3, 48   

    la a1, buffer     
    sb t2, 0(a1)      
    sb t3, 1(a1)      
    sb zero, 2(a1)    

    jr ra             