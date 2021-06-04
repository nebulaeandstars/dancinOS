.syntax unified
.global main
.include "lib/libcomp2300/macros.S"

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ MAIN

.type main, %function
main:
  @ enable the SYSCFG clock
  RCC_APB2ENR_set 0

  @ enable the SYSTICK timer, with an initial reload value of 1 millisecond.
  ldr r0, =4000
  bl SysTick_enable

  @ start redblink
  ldr r0, =redblink
  bl create_process

  @ start greenblink
  ldr r0, =greenblink
  bl create_process

  @ then enter into an infinite loop.
  loop:
    nop
    b loop
.size main, .-main
