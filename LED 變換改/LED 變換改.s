		AREA    LED1, CODE, READONLY
		ENTRY

        LDR     r0, =0x40000000      ; CPU = Instruction Set

        SUB     r7, r7, r7           ; clear out r7
        MOV     r6, #4               ; start with LED = 0b10
		MOV		r5, #0				 ; counter
mainloop; turn on the LED
        ; if bits [9:2] affect the writes, then the address
        ; is offset by 0x38
        STR     r6, [r0, #0x38]      ; base + 0x38 so [9:2] = 0b00111000
		TST     r5, #1
        BEQ     RGB
        BNE     BGR
        ;BL     DELAY
RGB     
		CMP     r6, #64
        ;ITE    LT
        LSLLT   r6, r6, #2           ; LED = LED * 2
        ;MOVGE  r6, #4               ; reset to 2 otherwise
        ADDGE   r5, r5, #1
        B       OUT
BGR     
		CMP     r6, #4
        ;ITE    LT
        LSRGT   r6, r6, #2           ; LED = LED * 2
        ;MOVLE  r6, #4               ; reset to 2 otherwise
        ADDLE   r5, r5, #1

OUT		

;        LDR     r7, =0xF40000        ; set counter to 0xF40000
;spin
;        SUBS    r7, r7, #1
;        BNE     spin
        ; change colors
		
        ;CMP     r6, #8
        ;ITE     LT
        ;LSLLT   r6, r6, #1           ; LED = LED * 2
        ;MOVGE   r6, #2               ; reset to 2 otherwise
        B       mainloop

DELAY	LDR		r7, =0xF40000		 ;set counter to 0xF40000
spin	
		SUBS	r7, r7, #1
		BNE		spin
		BX		LR
STOP    B       STOP
        END
