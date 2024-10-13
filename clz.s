main:
    li a0, 0x0100f219   # load input data
    jal ra, my_clz      # send my_clz function
    li a7, 10              
    ecall
    
# Function to count leading zeros (CLZ)
my_clz:
    addi sp, sp, -16    # create stack
    sw ra, 12(sp)       # store ra
    sw s0, 8(sp)        # store s0
    sw s1, 4(sp)        # store s1
    sw s2, 0(sp)        # store s2


    li s0, 31           # s0 = i
    li s1, 0            # s1 = count

loop:
    li s2, 0x1          # load 0x1
    sll s2, s2, s0      # shift left 
    and s2, a0, s2      # do "and" operation, take the left bit
    bne s2, x0, done    

    addi s1, s1, 1      # update count
    addi s0, s0, -1     # update i

    bge s0, x0, loop    # loop condition 

done:
    mv a0, s1           # put the answer into a0
    lw ra, 12(sp)       # load ra
    lw s0, 8(sp)        # load s0
    lw s1, 4(sp)        # load s1
    lw s2, 0(sp)        # load s2  
    addi sp, sp, 16     # release stack
    ret                 # return