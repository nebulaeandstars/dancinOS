.syntax unified

.global scheduler

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ FUNCTIONS

@@@ scheduler @@@
@ params:
@   none
@ return:
@   r0: the stack pointer for the process to be switched into.
.type scheduler %function
scheduler:
  stmdb sp!, {fp, lr}

  @ load the current process into r0
  ldr r2, =process_table
  ldr r0, [r2]

  @ load the number of processes into r1
  ldr r1, [r2, #4]

  @ add 1 to the current process to get to the next one, looping back around if
  @ there are too many, then store it back.
  add r0, #1
  cmp r0, r1
  IT ge
  movge r0, #0
  str r0, [r2]

  @ load the stack pointer for the next process into r0.
  mov r1, #4
  mul r1, r0
  add r2, r1
  add r2, #8
  ldr r0, [r2]

  ldmia sp!, {fp, lr}
  bx lr
.size scheduler, .-scheduler
