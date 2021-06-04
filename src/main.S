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

  ldr r0, =redblink
  bl create_process

.size main, .-main
