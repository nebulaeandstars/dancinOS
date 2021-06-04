.syntax unified
.include "lib/libcomp2300/macros.S"

.global greenblink

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ MAIN

@@@ greenblink @@@
@ does:
@   blinks the green LED forever
.type greenblink, %function
greenblink:
  @ enable the green LED
  GPIOx_clock_enable E
  GPIO_configure_output_pin E, 8

  loop:
    @ toggle the green LED, delay for a bit, and loop back around.
    GPIOx_ODR_toggle E, 8

    mov r0, #0x40000
    bl delay

    b loop
.size greenblink, .-greenblink
