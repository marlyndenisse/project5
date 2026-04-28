#This is starter code, so that you know the basic format of this file.
#Use _ in your system labels to decrease the chance that labels in the "main"
#program will conflict

.data
.text
_syscallStart_:
    beq $v0, $0, _syscall0 #jump to syscall 0
    addi $k1, $0, 1
    beq $v0, $k1, _syscall1 #jump to syscall 1
    addi $k1, $0, 5
    beq $v0, $k1, _syscall5 #jump to syscall 5
    addi $k1, $0, 9
    beq $v0, $k1, _syscall9 #jump to syscall 9
    addi $k1, $0, 10
    beq $v0, $k1, _syscall10 #jump to syscall 10
    addi $k1, $0, 11
    beq $v0, $k1, _syscall11 #jump to syscall 11
    addi $k1, $0, 12
    beq $v0, $k1, _syscall12 #jump to syscall 12
    #Error state - this should never happen - treat it like an end program
    j _syscall10

#Do init stuff
_syscall0:
    # Initialization goes here
    addi $sp, $0, 1023 #This is 0x03FF in decimal
    sll $sp, $sp, 16 #after shifting, $sp is 0x03FF0000
    sw $k1, 0($sp)   
    la $k1, _END_OF_STATIC_MEMORY_
    j _syscallEnd_

#Print Integer
_syscall1:
    # Print Integer code goes here
    addi $sp, sp, -20
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)
    sw $t4, 16($sp)

    addi $t0, a0, 0 #t0 = number
    addi $t1, $0, 10 #divisor 
    addi $t2, $zero, 0 #digit count

    #print zero
    bne $t0, $zero, jump
    addi $t3, $zero, 48
    sw $t3, -4096($0)
    j done

    jump:
    loop: 
        div $t0, $t1
        mfhi $t3 #remainder
        mflo $t0 #quotient 

        addi $sp, $sp -4($sp) #send digit 
        sw $t3, 0($sp)
        addi $t2, $t2, 1

        bne $t0, $zero, loop

    print: 
        beq $t2, $zero, done 

        lw $t4, 0($sp)
        addi $sp, $sp, 4
        addi $t4, $t4, 48
        sw $t4, -4096($0)

        addi $t2, $t2 -1
        j print

    done:
    lw $t4, 16($sp)
    lw $t3, 12($sp)
    lw $t2, 8($sp)
    lw $t1, 4($sp)
    lw $t0, 0($sp)
    addi $sp, $sp, 20
    jr $k0

#Read Integer
_syscall5:
    # Read Integer code goes here
    addi $sp, sp, -20
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $t3, 12($sp)
    sw $t4, 16($sp)

    addi $t0, $zero, 0 #counter = 0
    addi $t3, $0, 48 #'0'
    addi $t4, $0, 57 #'9'

    loop5:

    wait5: 
    lw $k1, -4080($0)
    beq $k1, $0, wait5

    #look at current character
    lw $t1, -4076($0)

    #if it is not a number done
    slt $k1, $t1, $t3
    bne $k1, $0, done5

    slt $k1, $t4, $t1
    bne $k1, $0, done5

    addi $t2, $t1, -48 #digit

    #counter = counter * 10 + digit 
    addi $t1, $zero, 10
    mult $t0, $t1
    mflo $t0
    add $t0, $t0, $t2

    sw $zero, -4080($zero)
    j loop5

    done5:
    add $v0, $t0, $zero
    lw $t4, 16($sp)
    lw $t3, 12($sp)
    lw $t2, 8($sp)
    lw $t1, 4($sp)
    lw $t0, 0($sp)
    addi $sp, $sp, 20 
    jr $k0

#Heap allocation
_syscall9:
    # Heap allocation code goes here
    lw $v0, 0(%sp)
    add $k1, $v0, $a0 
    sw $k1, 0(sp)
    jr $k0

#"End" the program
_syscall10:
    j _syscall10

#print character
_syscall11:
    sw $a0, -4096($0)     
    jr $k0

#read character
_syscall12
    loop:
        lw $k1, -4080($0)
        beq $k1, $zero, loop

        lw $v0, -4076($0)
        sw $zero, -4080($0)
        jr $k0

#extra credit syscalls go here?

_syscallEnd_:
