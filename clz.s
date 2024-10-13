.data
input: .word 0xf2133212 ,0x1c45f455,0x05151515
output: .word 0x00000000,0x00000003,0x00000005
yes_msg: .string "True \n"
no_msg: .string "False \n"
.text
main:
    la t0, input
    la t1, output
    li t2, 3
compare_loop:
    lw a0, 0(t0)
    lw a1, 0(t1)
    jal ra, my_clz
    beq a0, a1, print_yes
    j print_no
    
print_yes:
    la a0, yes_msg
    li a7, 4
    ecall 
    j next_compare
print_no:  
    la a0, no_msg
    li a7, 4
    ecall 
    j next_compare
next_compare:
    addi t0, t0, 4
    addi t1, t1, 4
    addi t2, t2, -1
    bnez t2, compare_loop
    li a7, 10
    ecall
    
# Function to count leading zeros (CLZ)
my_clz:
    li t3, 31           # s0 = i
    li t4, 0            # s1 = count

loop:
    li t5, 0x1          # load 0x1
    sll t5, t5, t3      # shift left 
    and t5, a0, t5      # do "and" operation, take the left bit
    bne t5, x0, done    

    addi t4, t4, 1      # update count
    addi t3, t3, -1     # update i

    bge t3, x0, loop    # loop condition 

done:
    mv a0, t4           # put the answer into a0
    ret                 # return