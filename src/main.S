.syntax unified
.global main
.include "lib/libcomp2300/macros.S"

.type main, %function
main:

  loop:
    nop
    b loop
.size main, .-main
