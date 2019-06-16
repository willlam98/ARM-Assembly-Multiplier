         BL      MUL32X32
         END

MUL32X32 
         STMFD   R13!, {R3-R9, R14}
         LDR     R2, [R2] ;MULTIPLICAND = a
         LDR     R1, [R1] ;MULTIPLIER = b
         ;BL     MUL16X16 ;a0b0
         MOV     R4, R0
         ;next   do a1b0
         ROR     R2, R2, #16
         ;BL     MUL16X16
         MOV     R5, R0
         ;do     a0b1
         ROR     R1, R1, #16
         ROR     R2, R2, #16
         ;BL     MUL16X16
         ADD     R0, R0, R5
         ADD     R4, R4, R0, LSL#16
         STR     R4, [R3]
         ;do     a1b1
         ROR     R2, R2, #16
         ;       BL MUL16X16
         STR     R0, [R3], #4
         ADDS    R0, R0, R4
         MOVCS   R5, #1
         STRHS   R5, [R3], #8
         LDMFD   R13!, {R3-R9, R15}

