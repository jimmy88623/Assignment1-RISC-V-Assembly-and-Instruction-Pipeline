.data
input: .word 0xf2133212 ,0x8c45f455,0x05151515
output: .word 0xf2133212,0x8c45f455,0x05151515
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
    jal ra, fabsf
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
    ecall   # system call  
     
fabsf:
    li t3, 0x7FFFFFFF
    and a0, a0, t3
    ret