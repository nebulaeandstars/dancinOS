.syntax unified
.global process_table

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ DATA

.data
process_table:
  .word 0 @ current process
  .word 0 @ number of processes
  .rept 1000
  .word 0
  .endr
