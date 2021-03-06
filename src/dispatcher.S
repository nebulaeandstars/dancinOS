.syntax unified

.global create_process
.global dispatcher

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ FUNCTIONS

@@@ create_process @@@
@ params:
@   r0: a label pointing to the entry point for the new process
@ does:
@   creates a new process and adds it to the process table
.type create_process, %function
create_process:
  push {r0, lr}

  @ find a spot for the new stack pointer
  bl create_stack_pointer

  @ keep the old stack pointer safe
  mov r3, sp
  mov r1, r0

  @ switch to the new context
  pop {r0, lr}
  mov sp, r1

  @ push the status register (default 0x01000000)
  ldr r1, =0x01000000
  push {r1} @ xPSR

  @ push the initial program counter
  push {r0} @ pc

  @ push the same value to the link register
  push {r0} @ lr

  @ allocate space for scratch register values
  sub sp, 20

  @ allocate space for non-scratch register values
  sub sp, 32

  @ Add 1 to the number of processes,
  ldr r1, =process_table
  ldr r0, [r1, #4]
  add r0, #1
  str r0, [r1, #4]

  @ add the new stack pointer to the process table,
  mov r2, #4
  mul r2, r0
  add r1, r2
  add r1, #4
  str sp, [r1]

  @ return to the old context,
  mov sp, r3

  @ and return.
  bx lr
.size create_process, .-create_process


@@@ create_stack_pointer @@@
@ params:
@   none
@ return:
@   r0: the address of an unused stack pointer
.type create_stack_pointer %function
create_stack_pointer:

  @ TODO: this is fairly naive, and doesn't allow processes to exit

  @ load the number of processes into r0
  ldr r0, =process_table
  ldr r0, [r0, #4]

  @ multiply by 1000 (1Kb per process)
  mov r1, #1000
  mul r0, r1

  @ add to the base of the stack space
  ldr r1, =stack_space
  add r0, r1

  @ add 1000 to get the *end* of the block (rather than the beginning)
  add r0, #1000

  bx lr
.size create_stack_pointer, .-create_stack_pointer


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ HANDLERS

@@@ dispatcher @@@
@ params:
@   none
@ return:
@   none
@ does:
@   finds a process to switch into, then performs a context switch.
.global dispatcher
.type dispatcher, %function
dispatcher:
  push {lr}

  @ Get the stack pointer for the process to switch into.
  bl scheduler

  @ Push non-scratch register values
  pop {lr}
  stmdb sp!, {r4, r5, r6, r7, r8, r9, r10, r11}

  @ Switch to the new context
  mov sp, r0

  @ Load non-scratch register values
  ldmia sp!, {r4, r5, r6, r7, r8, r9, r10, r11}

  @ Finally, return into the new process
  bx lr
.size dispatcher, .-dispatcher

@ dispatcher trigger
.weak SysTick_Handler
.thumb_set SysTick_Handler, dispatcher


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ DATA

.data
stack_space:
.rept 10000
.word 0
.endr
