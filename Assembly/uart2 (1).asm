.ORIG x0500

START   LD    R2, BASE

WAIT_KBD LDR  R0, R2, #0    ; VIO KBSR
         BRzp WAIT_KBD
         LDR  R0, R2, #2    ; read VIO KBDR

WAIT_TX  LDR  R1, R2, #5    ; UART2 DSR
         BRzp WAIT_TX
         STR  R0, R2, #7    ; write to UART2 DDR

         BRnzp START

BASE    .FILL xFE00

        .END