.syntax unified
.global main
.include "lib/libcomp2300/macros.S"

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ MAIN

.type main, %function
main:

  ldr r0, =redblink
  bl create_process

.size main, .-main
