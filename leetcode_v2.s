.data
arr: .word 1,3,4,5,6,8,3,3,1
msg_true: .string "True \n"
msg_false: .string "False \n"
.text
main:
    la      s10, arr             # Load address of array into s10
    li      a1, 9                # Load array size into a1
    call    threeConsecutiveOdds # Call the function
    
    # Check the returned result and print appropriate message
    beq     a0, x0, print_false  # If 0 (false), jump to print_false
    j       print_true           # Else, jump to print_true

print_true:
    la      a0, msg_true         # Load address of "True" message into a0
    li      a7, 4                # Syscall for print string
    ecall                        # Make the system call
    li      a7, 10               # Syscall for exit
    ecall                        # End the program after printing

print_false:
    la      a0, msg_false        # Load address of "False" message into a0
    li      a7, 4                # Syscall for print string
    ecall
    li      a7, 10               # Syscall for exit
    ecall                        # Exit the program

threeConsecutiveOdds:
    addi    s8, x0, 0            # Initialize count to 0
    addi    s9, x0, 0            # Initialize i to 0
    li      s2, 3                # Load 3 for consecutive check
    
loop_start:
    bge     s9, a1, print_false  # if i >= arrSize, return false
    
    lw      s4, 0(s10)           # Load arr[i] into s4
    addi    s10, s10, 4          # Move to next array element
    
    andi    s5, s4, 1            # Check if arr[i] is odd (last bit == 1)
    beqz    s5, reset_count      # If not odd, reset count
    addi    s8, s8, 1            # Increment count
    beq     s8, s2, print_true   # If count == 3, return true
    addi    s9, s9, 1            # i++
    j       loop_start           # Jump to start of the loop

reset_count:
    addi    s8, x0, 0            # Reset count to 0
    addi    s9, s9, 1            # i++
    j       loop_start           # Jump to start of the loop

my_clz:
    addi    sp, sp, -8           # Allocate stack space
    sw      ra, 4(sp)            # Store return address
    sw      s0, 0(sp)            # Store s0 (loop counter)

    li      s0, 31               # Set loop counter to 31
    li      a0, 0                # Initialize count of leading zeros

clz_loop:
    srl    s5, a1, s0            # Shift right by s0 bits
    andi    s5, s5, 1            # Isolate the least significant bit
    bnez    s5, clz_done         # If we find a 1, break the loop
    addi    a0, a0, 1            # Increment the count
    addi    s0, s0, -1           # Decrement the loop counter
    bgez    s0, clz_loop         # Repeat until s0 >= 0

clz_done:
    lw      ra, 4(sp)            # Restore return address
    lw      s0, 0(sp)            # Restore s0
    addi    sp, sp, 8            # Free stack space
    ret                          # Return