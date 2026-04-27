.data
.text
.align 2 
.globl main
#write two integers separated by a space or enter, print the sum
main:
  addi $v0, $0, 5
  syscall #read one integer
  add $s0, $0, $v0
  addi $v0, $0, 12
  syscall #read extra character
  addi $v0, $0, 5
  syscall #read another integer
  add $a0, $s0, $v0
  addi $v0, $0, 1
  syscall #print the sum
