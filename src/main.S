.syntax unified
.global main
.include "lib/libcomp2300/macros.S"

.type main, %function
main:

  bl redblink
.size main, .-main
