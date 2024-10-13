.data
arr: .word 7,7,7
msg_true: .string "True \n"
msg_false: .string "False \n"
.text
main:
    la      s10, arr               # Load address of array into a0 (first argument to function)
    li      a1, 3                # Load array size (6 in this case) into a1 (second argument)
    call    threeConsecutiveOdds  # Call the function
    
    # Check the returned result and print appropriate message
    beq     a0, x0, print_false   # If returned value is 0 (false), jump to print_false
    j       print_true            # Else, jump to print_true

print_true:
    li a0,1
    la      a0, msg_true          # Load address of "True" message into a0
    li      a7, 4                 # Syscall for print string
    ecall                        # Make the system call
    li      a7, 10                # Syscall for exit
    ecall            # End the program after printing

print_false:
    li a0, 0
    la      a0, msg_false         # Load address of "False" message into a0
    li      a7, 4                 # Syscall for print string
    ecall
    li      a7, 10                # Syscall for exit
    ecall  
                          # Exit the program

threeConsecutiveOdds:
    addi    s8, x0, 0            # Initialize count to 0 (s0 = count)
    addi    s9, x0, 0            # Initialize i to 0 (s1 = loop counter)
    li      s2, 3                # Load 3 into s2 (for checking consecutive count)
    
loop_start:
    bge     s9, a1, print_false # if i >= arrSize, return false
    
    slli    s3, s9, 2            # Calculate offset for arr[i] (s3 = i * 4)
    add     s3, s10, s3           # Load address of arr[i] into s3
    lw      s4, 0(s3)            # Load arr[i] into s4
    
    slli    s5, s4, 31           # Shift value left by 31 bits
    srli    s5, s5, 31           # Shift value right by 31 bits (extract last bit)
    
    mv      a0,s5
    li      s7, 0x1f  
    jal ra, my_clz        # Use clz to count leading zeros in s5 
    beq a0, s7, increment_count  # If leading zeros == 31, increment count
    j reset_count
reset_count:
    addi    s8, x0, 0            # Reset count to 0
    addi    s9, s9, 1            # i++
    j       loop_start           # Jump to start of the loop
    
increment_count:
    addi    s8, s8, 1            # count++
    beq     s8, s2, print_true  # If count == 3, return true
    addi    s9, s9, 1            # i++
    j       loop_start           # Jump to start of the loop
    


my_clz:
    addi sp, sp, -24    # create stack
    sw ra, 20(sp)       # store ra 
    sw s0, 16(sp)       # store s0
    sw s1, 12(sp)       # store s1
    sw s2, 8(sp)        # store s2
    sw s3, 4(sp)        # store s3
    sw s4, 0(sp)        # store s4  

    li s0, 31           # s0 = i
    li s1, 0            # s1 = count

loop:
    li s4, 0x1          # load 0x1
    sll s2, s4, s0      # shift left 
    and s3, a0, s2      # do "and" operation, take the left bit
    bne s3, x0, done     
  
    addi s1, s1, 1      # update count
    addi s0, s0, -1     # update i  

    bge s0, x0, loop    # loop condition

done:
    mv a0, s1           # put the result into a0 
    lw ra, 20(sp)       # load ra
    lw s0, 16(sp)       # load s0
    lw s1, 12(sp)       # load s1
    lw s2, 8(sp)        # load s2
    lw s3, 4(sp)        # load s3
    lw s4, 0(sp)        # load s4  
    addi sp, sp, 24     # release stack
    ret                 # return 