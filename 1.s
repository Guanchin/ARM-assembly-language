	AREA Reset, CODE, READONLY
    ENTRY
	;411440398 Guan-Ching
    ; Initialize register values
    LDR     R0, =0xBBBBBBBB
    LDR     R1, =0xFFFFFFFF
    LDR     R2, =0xEEEEEEEE
    LDR     R3, =0xDDDDDDDD

    ; Set base address for memory operations
    LDR     R12, =0x40000020

    ; Store values into memory with STMIA
    STMIA   R12, {R0,R1,R2,R3}

    ; Load values from memory into r4-r7 with LDMDA
    LDMDA   R12, {R4,R5,R6,R7}
    ; Reset R4-R7 to a known state for demonstration
    MOV     R4, #0
    MOV     R5, #0
    MOV     R6, #0
    MOV     R7, #0
	;411440398 Guan-Ching
	
    ; Load values from memory into r4-r7 with LDMDB
    LDMDB   R4, {R4-R7}
    ; Reset R4-R7 to a known state for demonstration
    MOV     R4, #0
    MOV     R5, #0
    MOV     R6, #0
    MOV     R7, #0
	;411440398 Guan-Ching

    ; Load values from memory into r4-r7 with LDMIA
    LDMIA   R12, {R4-R7}
    ; Reset R4-R7 to a known state for demonstration
    MOV     R4, #0
    MOV     R5, #0
    MOV     R6, #0
    MOV     R7, #0
	;411440398 Guan-Ching
	
    ; Load values from memory into r4-r7 with LDMIB
    LDMIB   R12, {R4-R7}
done B done
    END
