main:
    li a0, 0x3c00
    jal ra, fp16_to_fp32 
    li a7, 10              
    ecall
                

fp16_to_fp32:
    addi sp, sp, -32     
    sw ra, 28(sp)         
    sw s0, 24(sp)         
    sw s1, 20(sp)
    sw s2, 16(sp)
    sw s3, 12(sp)
    sw s4, 8(sp)          
    sw s5, 4(sp)
    sw s6, 0(sp)         

    mv s0, a0           # s0 store input uint16      
    slli s1, s0, 16     # s1 store w   
    li t1, 0x80000000       
    and s2, s1, t1      # s2 store sign
    li t1, 0x7FFFFFFF       
    and s3, s1, t1      # s3 store nonsign    

    mv a0, s3           #    
    jal ra, my_clz       
    mv s4, a0           # s4 store my_clz result(renorm_shift)     

    li s5, 6            # s5 store temp 5       
    blt s4, s5, set_zero     
    addi s4, s4, -5
    j go        
set_zero:
    li s4, 0 
     
go:
    li t2, 0x04000000        
    add s5, s3, t2           
    srli s5, s5, 8           
    li t2, 0x7F800000       
    and s5, s5, t2     # s5 update store inf_nan_mask       
    
    addi s6, s3, -1         
    srli s6, s6, 31    # s6 store zero_mask
    
    sll s3, s3, s4     # nonsign << renorm_shift
    srli s3, s3, 3     # s3 store (nonsign << renorm_shift >> 3)
    
    li t1, 0x70
    sub t1, t1, s4     # (0x70 - renorm_shift)
    slli t1, t1, 23    # t1 store ((0x70 - renorm_shift) << 23)
    
    add s3, s3, t1
    or s3, s3, s5
    
    not t1, s6
    and s3, s3, t1
    
    or s3, s3, s2
    mv a0, s3
    
    lw ra, 28(sp)         
    lw s0, 24(sp)         
    lw s1, 20(sp)
    lw s2, 16(sp)
    lw s3, 12(sp)
    lw s4, 8(sp)          
    lw s5, 4(sp)
    lw s6, 0(sp)         
    addi sp, sp, 32
    ret
    


# Function to count leading zeros (CLZ)
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