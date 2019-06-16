MUL128X128       
                 STMFD   R13!, {R1-R10, R14}
                 MOV     R4, #4

                 MOV     R10,#0

                 LDR     R5,[R2,#12]
                 ANDS    R5,R5,#0x80000000

                 BEQ     A0LOOP ;sign convertion if it's -ve

                 MOV     R10,#1
                 LDR     R6,[R2]
                 LDR     R7,[R2,#4]
                 LDR     R8,[R2,#8]
                 LDR     R9,[R2,#12]

                 RSBS    R6,R6,#0
                 STR     R6,[R2]

                 MVN     R7,R7
                 ADCS    R7,R7,#0
                 STR     R7,[R2,#4]

                 MVN     R8,R8
                 ADCS    R8,R8,#0
                 STR     R8,[R2,#8]

                 MVN     R9,R9
                 ADC     R9,R9,#0
                 STR     R9,[R2,#12]

                 ;a      = a3*2^96 + a2*2^64 + a1*2^32 + a0 (a0 < 2^32)
                 ;b      = b3*2^96 + b2*2^64 + b1*2^32 + b0 (b0 < 2^32)

                 ;ab     = a3b3*2^192 + a2b3*2^160 + a1b3*2^128 + a0b3*2^96
                 ;+      a3b2*2^160 + a2b2*2^128 + a1b2*2^96 + a0b2*2^64
                 ;+      a3b1*2^128 + a2b1*2^96 + a1b1*2^64 + a0b1*2^32
                 ;+      a3b0*2^96 + a2b0*2^64 + a1b0*2^32 + a0b0
                 ;       R1:= b R2:= a

A0LOOP           STMFD   R13!, {R1, R2}
                 BL      MUL32X32
                 LDMFD   R13!, {R1, R2}
                 ADD     R1, R1, #4
                 ADD     R3, R3, #4
                 SUBS    R4, R4, #1
                 BNE     A0LOOP

                 MOV     R4, #4
                 ADD     R2, R2, #4
                 SUB     R1, R1, #16
                 SUB     R3, R3, #12

A1LOOP           STMFD   R13!, {R1, R2}
                 BL      MUL32X32
                 LDMFD   R13!, {R1, R2}
                 ADD     R1, R1, #4
                 ADD     R3, R3, #4
                 SUBS    R4, R4, #1
                 BNE     A1LOOP

                 MOV     R4, #4
                 ADD     R2, R2, #4
                 SUB     R1, R1, #16
                 SUB     R3, R3, #12

A2LOOP           STMFD   R13!, {R1, R2}
                 BL      MUL32X32
                 LDMFD   R13!, {R1, R2}
                 ADD     R1, R1, #4
                 ADD     R3, R3, #4
                 SUBS    R4, R4, #1
                 BNE     A2LOOP

                 MOV     R4, #4
                 ADD     R2, R2, #4
                 SUB     R1, R1, #16
                 SUB     R3, R3, #12

A3LOOP           STMFD   R13!, {R1, R2}
                 BL      MUL32X32
                 LDMFD   R13!, {R1, R2}
                 ADD     R1, R1, #4
                 ADD     R3, R3, #4
                 SUBS    R4, R4, #1
                 BNE     A3LOOP

                 SUB     R3, R3, #28
                 CMP     R10,#1
                 BNE     SIGNEDCONV ;convert back the sign
                 LDR     R4,[R3]
                 LDR     R5,[R3,#4]
                 LDR     R6,[R3,#8]
                 LDR     R7,[R3,#12]

                 RSBS    R4,R4,#0
                 STR     R4,[R3]

                 MVN     R5,R5
                 ADCS    R5,R5,#0
                 STR     R5,[R3,#4]

                 MVN     R6,R6
                 ADCS    R6,R6,#0
                 STR     R6,[R3,#8]

                 MVN     R7,R7
                 ADCS    R7,R7,#0
                 STR     R7,[R3,#12]

                 LDR     R4,[R3,#16]
                 LDR     R5,[R3,#20]
                 LDR     R6,[R3,#24]
                 LDR     R7,[R3,#28]

                 MVN     R4,R4
                 ADCS    R4,R4,#0
                 STR     R4,[R3,#16]

                 MVN     R5,R5
                 ADCS    R5,R5,#0
                 STR     R5,[R3,#20]

                 MVN     R6,R6
                 ADCS    R6,R6,#0
                 STR     R6,[R3,#24]

                 MVN     R7,R7
                 ADC     R7,R7,#0
                 STR     R7,[R3,#28]

SIGNEDCONV       

                 LDMFD   R13!, {R1-R10, R15}


