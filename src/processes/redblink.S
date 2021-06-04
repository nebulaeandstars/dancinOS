.syntax unified
.include "lib/libcomp2300/macros.S"

.global redblink

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ MAIN

@@@ redblink @@@
@ does:
@   blinks the red LED forever
.type redblink, %function
redblink:
  @ enable the red LED
  GPIOx_clock_enable B
  GPIO_configure_output_pin B, 2

  loop:
    @ toggle the red LED, delay for a bit, and loop back around.
    GPIOx_ODR_toggle B, 2

    mov r0, #0x20000
    bl delay

    b loop
.size redblink, .-redblink
