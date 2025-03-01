.data
array: .word 1, 3, 5, 7, 9, 11, 13, 15, 17, 19  # Sorted array
size: .word 10  # Number of elements in the array
key: .word 0    # Placeholder for user input
result: .word -1  # Placeholder for the result index
prompt: .asciz "\nEnter the number to search: "  # User prompt
answer: .asciz "The key is at index: "

.text
.globl main

main:
    # Print the array
    la a0, array
    lw a1, size
    jal ra, print_array

    # Ask user for key to search
    li a7, 4
    la a0, prompt
    ecall

    # Read user input
    li a7, 5
    ecall
    la t0, key
    sw a0, 0(t0)

    # Load array address and size again
    la a0, array
    lw a1, size 
    lw a2, key

    # Call binary search procedure
    jal ra, binary_search

    # Store result in memory
    la a3, result
    sw a0, 0(a3)

    # Print result
    la a0, answer
    li a7, 4
    ecall
    lw a0, result
    li a7, 1
    ecall

    # Exit program
    li a0, 0
    li a7, 93
    ecall

# Print array procedure
print_array:
    li t0, 0      # Counter
    la t1, array

print_loop:
    bge t0, a1, print_done  # If counter >= size, stop
    lw a0, 0(t1)
    li a7, 1
    ecall
    li a7, 11     # Print space (newline)
    li a0, 32     # ASCII space
    ecall
    addi t1, t1, 4  # Move to next element
    addi t0, t0, 1  # Increment counter
    j print_loop

print_done:
    ret

# Binary search procedure
# a0 = base address of array
# a1 = size of array
# a2 = search key
# Returns index in a0 (or -1 if not found)
binary_search:
    li a3, 0         # Left index (low)
    addi a4, a1, -1  # Right index (high)

binary_loop:
    blt a4, a3, not_found  # If high < low, element not found
    add a5, a3, a4  # mid = (low + high)
    srli a5, a5, 1  # mid /= 2

    slli a6, a5, 2  # Convert index to byte offset
    add a6, a6, a0  # Address of array[mid]
    lw a7, 0(a6)    # Load array[mid]

    beq a7, a2, found  # If array[mid] == key, return mid
    blt a7, a2, move_right  # If array[mid] < key, search right
    addi a4, a5, -1  # high = mid - 1
    j binary_loop

move_right:
    addi a3, a5, 1  # low = mid + 1
    j binary_loop

found:
    mv a0, a5  # Store found index in a0
    ret

not_found:
    li a0, -1  # Store -1 if not found
    ret
