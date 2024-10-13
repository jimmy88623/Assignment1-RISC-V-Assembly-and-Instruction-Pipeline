.data
input: .word 0x3C00, 0x4000, 0x6219
output: .word 0x3F800000, 0x40000000, 0x44432000
yes_msg: .string "True \n"
no_msg: .string "False \n"
.text
main:
    la t3, input
    la t4, output
    li t5, 3
compare_loop:
    lw a0, 0(t3)
    lw a1, 0(t4)
    jal ra, fp16_to_fp32
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
    addi t3, t3, 4
    addi t4, t4, 4
    addi t5, t5, -1
    bnez t5, compare_loop
    li a7, 10
    ecall
                

fp16_to_fp32:
    addi sp, sp, -16     
    sw ra, 12(sp)        
    sw a0, 8(sp)         

    lw s0, 8(sp)               
    slli s1, s0, 16      
    li t1, 0x80000000       
    and s2, s1, t1      
    li t1, 0x7FFFFFFF       
    and s3, s1, t1         

    mv a0, s3           
    jal ra, my_clz       
    mv s4, a0           

    li s5, 6            
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
    and s5, s5, t2     
    
    addi s6, s3, -1         
    srli s6, s6, 31   
    
    sll s3, s3, s4     
    srli s3, s3, 3    
    
    li t1, 0x70
    sub t1, t1, s4     
    slli t1, t1, 23    
    
    add s3, s3, t1
    not t1, s6
    and s3, s3, t1
    
    or s3, s3, s2
    mv a0, s3

    lw ra, 12(sp)         
    addi sp, sp, 16      
    ret                 

my_clz:
    addi sp, sp, -16    
    sw ra, 12(sp)       
    sw a0, 8(sp)       

    li s0, 31           
    li s1, 0            

loop:
    li s2, 0x1          
    sll s2, s2, s0      
    and s2, a0, s2      
    bne s2, x0, done    

    addi s1, s1, 1      
    addi s0, s0, -1     
    bge s0, x0, loop    

done:
    mv a0, s1           
    lw ra, 12(sp)       
    addi sp, sp, 16     
    ret                 