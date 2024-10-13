main:
    li a0, 0xf2123132    # load input 
    jal ra, fabsf        # send fabsf function
    li a7, 10                
    ecall                # system call 
    
fabsf:
    addi sp, sp, -12     # create stack
    sw s0 ,8(sp)         # store s0
    sw s1 ,4(sp)         # store s1
    sw ra, 0(sp)         # store ra
         
    li s1, 0x7FFFFFFF    # load mask
    and s0, a0, s1       # do operation
    mv a0, s0            # put the operation result to a0
       
    lw s0, 8(sp)         # load s0   
    lw s1, 4(sp)         # load s1
    lw ra, 0(sp)         # load ra 
    addi sp, sp, 12      # release stack 
    ret                  # return 