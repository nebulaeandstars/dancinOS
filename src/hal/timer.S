.syntax unified

.global SysTick_enable, SysTick_reset, SysTick_change_priority

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ FUNCTIONS

@@@ SysTick_enable @@@
@ params:
@   r0: initial value for the timer
@ returns:
@   none
@ does:
@   enables the SysTick timer
.type SysTick_enable, %function
SysTick_enable:
  stmdb sp!, {fp, lr}
  push {r0}

  @ set the 'clksource' bit
  ldr r0, =ADR_SYST
  ldr r1, =OFS_SYST_CSR
  mov r2, #2
  bl set_bit

  @ set the 'tickint' bit
  ldr r0, =ADR_SYST
  ldr r1, =OFS_SYST_CSR
  mov r2, #1
  bl set_bit

  @ reset the timer to use the initial value
  pop {r0}
  bl SysTick_reload
  bl SysTick_reset

  @ finally, set the 'enable' bit
  ldr r0, =ADR_SYST
  ldr r1, =OFS_SYST_CSR
  mov r2, #0
  bl set_bit

  ldmia sp!, {fp, lr}
  bx lr
.size SysTick_enable, .-SysTick_enable


@@@ SysTick_reload @@@
@ params:
@   r0: value to reload the timer with.
@ returns:
@   none
@ does:
@   stores r0 in OFS_SYST_RVR
.type SysTick_reload, %function
SysTick_reload:

  @ load the initial value into OFS_SYST_RVR
  ldr r1, =ADR_SYST
  ldr r2, =OFS_SYST_RVR
  str r0, [r1, r2]

  bx lr
.size SysTick_reload, .-SysTick_reload


@@@ SysTick_reset @@@
@ params:
@   none
@ returns:
@   none
@ does:
@   sets the timer to 0, loading the next value.
.type SysTick_reset, %function
SysTick_reset:
  stmdb sp!, {fp, lr}

  @ reset OFS_SYST_CVR
  ldr r0, =ADR_SYST
  ldr r1, =OFS_SYST_CVR
  str r0, [r0, r1]

  ldmia sp!, {fp, lr}
  bx lr
.size SysTick_reset, .-SysTick_reset


@@@ SysTick_change_priority @@@
@ params:
@   none
@ returns:
@   none
@ does:
@   sets the timer to 0, loading the next value.
.type SysTick_change_priority, %function
SysTick_change_priority:
  stmdb sp!, {fp, lr}

  ldr r0, =0xe000ed20
  mov r1, #0b11111111
  mov r2, #24
  mov r3, #8
  bl copy_bits

  ldmia sp!, {fp, lr}
  bx lr
.size SysTick_change_priority, .-SysTick_change_priority

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CONSTANTS

.set ADR_SYST, 0xe000e010
.set OFS_SYST_CSR, 0x0
.set OFS_SYST_RVR, 0x4
.set OFS_SYST_CVR, 0x8
.set OFS_SYST_CALIB, 0xc
