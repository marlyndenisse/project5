.data
.text
.globl main

main:
    #allocate memory for board 
    add $a0, $zero, 1
    sll $a0, $a0, 18 #a0 = 262144 = 256*256 *4

    addi $v0, $zero, 9 #syscall 9
    syscall

    add $t7, $v0, $0 #board base address

    #clear board memory
    add $t0, $t7, $0 #current board address

    addi $t1, $zero, 1 
    sll $t1, $t1, 16 #65536 cells

_clear_board: 
    beq $t1, $zero, _clear_board_done 

    sw $zero, 0($t0) #boardcell = 0

    addi $t0, $t0, 4 #move to next board cell
    addi $t1, $t1, -1 #cells left - 1

_clear_board_done:
    addi $s0, $zero, 256    #screenw
    addi $s1, $zero, 256    #screenh
    addi $s2, $zero, 128    #snakex
    addi $s3, $zero, 128    #snakey
    addi $s4, $zero, 1  #xdirection
    addi $s5, $zero, 0  #ydirection
    addi $s6, $zero, 0  #total steps 
    addi $s7, $zero, 255    #color

    #Mark position as visited 
    sll $t0, $s3, 8 #$t0 = snakey * 256
    add $t0, $t0, $s2 #$t0 = snakey * 256 + snakex
    sll $t0, $t0, 2 #$t0 =(snakey * 256 + snakex)* 4
    add $t0, $t7, $t0   #index = board address[snakex][snakey]

    add $t1, $zero, 1
    sw $t1, 0($t0) #board[snakex][snakey] = 1 #!!!!!????


game_loop:
    #delay
    addi $t0, $zero, 2000
 _delay_loop:
    beq $t0, $zero, _delay_done
    addi $t0, $t0, -1
    j _delay_loop

_delay_done:
    #check if a key has been pressed
    lw $t1, -4080($zero)
    beq $t1, $zero, _no_key_press #if no key, skip read

    lw $t2, -4076($0) #keyboard data

    #if key = w, move up
    addi $t3, $zero, 119 
    bne $t2, $t3, _check_a

    addi $s4, $zero, 0 #xdirection = 0
    addi $s5, $zero, -1 #ydirection = -1
    j _consume_key


_check_a:
    #if key = a, move left
    addi $t3, $zero, 97
    bne $t2, $t3, _check_s

    addi $s4, $zero, 0 #xdirection = -1
    addi $s5, $zero, -1 #ydirection = 0
    j _consume_key


_check_s:
    #if key = s, move down
    addi $t3, $zero, 115
    bne $t2, $t3, _check_d

    addi $s4, $zero, 0 #xdirection = 0
    addi $s5, $zero, -1 #ydirection = 1
    j _consume_key


_check_d:
    #if key = d, move right
    addi $t3, $zero, 100
    bne $t2, $t3, _consume_key

    addi $s4, $zero, 0 #xdirection = 1
    addi $s5, $zero, -1 #ydirection = 0

    

_consume_key:
    sw $zero, -4080($0)

_no_key_press:
    add $s2, $s2, $s4 #change xdirection
    add $s3, $s3, $s5   #change ydirection
  
    #if snakex < 0, game over
    slt $t0, $s2, $zero
    bne $t0, $zero, _game_over

    #if snakey < 0, game over
    slt $t0, #s3, $zero
    bne $t0, $zero, _game_over

   #if snakex >= screenw, game over
    slt $t0, $s2, $s0
    beq $t0, $0, _game_over

    #if snakey >= screenh, game over
    slt $t0, $s3, $s1
    beq $t0, $zero, _game_over

    #collision check 
    sll $t0, $s3, 8 #$t0 = snakey * 256
    add $t0, $t0, $s2 #$t0 = snakey * 256 + snakex
    sll $t0, $t0, 2 #$t0 =(snakey * 256 + snakex)* 4
    add $t0, $t7, $t0   #index = board address[snakex][snakey]


    #if board[snakex][snakey] = 1, game over
    lw $t1, 0($t0)
    bne $t1, $zero, _game_over

    #Mark the current spot as visited 
    addi $t1, $zero, 1
    sw $t1, 0($t0) #!!!!!?????


    addi $s6, $s6, 1 #totalSteps + 1

    #displayPixel(snakex, snakey)
    sw $s2, -4064($zero) 
    sw $s3, -4060($zero)
    sw $s7, -4056($zero)
    sw $zero, -4052($zero)

    j game_loop

 _game_over:
    #print total steps
    addi $a0, $s6, 0 
    addi $v0, $0, 1 #syscall 1
    syscall

    addi $v0, $zero, 10 #syscall 10
    syscall









