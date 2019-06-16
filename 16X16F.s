MUL16X16         ;shift  and look up N and C flags so we can check 2bits
                 STMFD   R13!, {R3-R4, R14}

                 MOV     R0, #0
                 LSL     R3, R2, #16

                 LSLS    R4, R1, #31
                 ADDMI   R0, R0, R3, LSR #16
                 ADDHS   R0, R0, R3, LSR #15

                 LSLS    R4, R1, #29
                 ADDMI   R0, R0, R3, LSR #14
                 ADDHS   R0, R0, R3, LSR #13

                 LSLS    R4, R1, #27
                 ADDMI   R0, R0, R3, LSR #12
                 ADDHS   R0, R0, R3, LSR #11

                 LSLS    R4, R1, #25
                 ADDMI   R0, R0, R3, LSR #10
                 ADDHS   R0, R0, R3, LSR #9

                 LSLS    R4, R1, #23
                 ADDMI   R0, R0, R3, LSR #8
                 ADDHS   R0, R0, R3, LSR #7

                 LSLS    R4, R1, #21
                 ADDMI   R0, R0, R3, LSR #6
                 ADDHS   R0, R0, R3, LSR #5

                 LSLS    R4, R1, #19
                 ADDMI   R0, R0, R3, LSR #4
                 ADDHS   R0, R0, R3, LSR #3

                 LSLS    R4, R1, #17
                 ADDMI   R0, R0, R3, LSR #2
                 ADDHS   R0, R0, R3, LSR #1

                 LDMFD   R13!, {R3-R4, R15}

MUL32X32         
                 STMFD   R13!, {R1-R9, R14}
                 LDR     R2, [R2] ;MULTIPLICAND = a
                 LDR     R1, [R1] ;MULTIPLIER = b

                 BL      MUL16X16
                 MOV     R4, R0 ;a0b0

                 ;next   do a1b0
                 ROR     R2, R2, #16
                 BL      MUL16X16
                 MOV     R5, R0 ;a1b0

                 ;do     a0b1
                 ROR     R1, R1, #16
                 ROR     R2, R2, #16
                 BL      MUL16X16
                 ADDS    R0, R0, R5 ;a0b1 + a1b0
                 LSR     R8, R0, #16
                 ADDCS   R8, R8, #0X00010000 ;add to a1b1 if overflow


                 ADDS    R4, R4, R0, LSL#16 ; P(31:0)
                 ADC     R8, R8, #0 ;add carry

                 ;do     a1b1
                 ROR     R2, R2, #16
                 BL      MUL16X16
                 ADD     R0, R0, R8 ;P(63:32)

                 LDR     R1, [R3] ;mem[R3]
                 LDR     R2, [R3, #4] ;mem[R3+4]

                 ADDS    R1, R4, R1
                 STR     R1, [R3], #4 ;put into mem[R3]

                 ADCS    R2, R2, R0 ;done mem[R3+4]
                 STR     R2, [R3], #4 ;put into mem[R3+4]

CARRYPROPAGATION 
                 LDR     R1, [R3]
                 ADCS    R1, R1, #0
                 STR     R1, [R3], #4
                 BCS     CARRYPROPAGATION

                 LDMFD   R13!, {R1-R9, R15}

