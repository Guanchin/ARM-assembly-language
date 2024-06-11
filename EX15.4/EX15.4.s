		AREA test2,code,readonly

		;MOVW r0, #0xE000
		;MOVT r0, #0x400F
		ldr r0,=0x400FE000
		;MOVW r2, #0x60 ; offset 0x060 for this register
		MOV r2, #0x60
		;MOVW r1, #0x0540
		;MOVT r1, #0x01C0;r1=0x54001C0
		ldr r1, =0x54001C0
		STR r1, [r0, r2] ; write the register�s content base 0x400FE000->0x400FE060
		
		;MOVW r7, #0x604 ; enable timer0 - RCGCTIMER
		ldr r7, =0x604
	;LDR r1, [r0, r7] ; p. 321, base ,0x400FE000->0x400FE604
		ORR r1, #0x1 ; offset - 0x604
	;STR r1, [r0, r7] ; bit 0
		
		NOP
		NOP
		NOP
		NOP
		NOP ; give myself 5 clocks per spec
		
		;MOVW r8, #0x0000 ; configure timer0 to be
		;MOVT r8, #0x4000 ; one-shot, p.698 GPTMTnMR r8=0x40000000
		ldr r8,=0x40030000
		;MOVW r7, #0x4 ; base 0x40030000
		MOV r7, #0x4
	;LDR r1, [r8, r7] ; offset 0x4,base 0x40030000->base 0x40030004
		ORR r1, #0x21 ; bit 5 = 1, 1:0 = 0x1
	;STR r1, [r8, r7]
		
	;LDR r1, [r8] ; set as 16-bit timer only
		ORR r1, #0x4 ; base 0x40030000
	;STR r1, [r8] ; offset 0, bit[2:0] = 0x4
		
		;MOVW r7, #0x30  ; set the match value at 0,
		ldr r8,=0x40000000
		MOV r7, #0x30
		ldr r1, =0xFB87973F ; since we counting down, 0xFFFFFFFF-47868C0(5*15M)=matchvalue
		STR r1, [r8, r7] ; offset - 0x30,base 0x40000000->base 0x40000030
		
		ldr sp,=0x40000090
		bl Get_Match
		
		;MOVW r7, #0x18 ; set bits in the GPTM
		ldr r8,=0x40030000
		MOV r7, #0x18
		LDR r1, [r8, r7] ; Interrupt Mask Register
		ORR r1, #0x10 ; p. 714 - base: 0x40030000
		STR r1, [r8, r7] ; offset - 0x18, bit 4,base 0x40030000->base 0x40030018
		
		;MOVW r6, #0xE000 ; enable interrupt on timer0
		;MOVT r6, #0xE000 ; p. 132, base 0xE000E000
		ldr r6,=0xE000E000
		;MOVW r7, #0x100 ; offset - 0x100, bit 19
		MOV r7, #0x100 
		ldr r2,[r6,r7];read
		MOV r1, #(1<<19) ; enable bit 19 for timer0
		orr r2,r2,r1;modify
		STR r2, [r6, r7];base 0xE000E000->base 0xE008E000,write
		
		;MOVW r6, #0x0000 ; start the timer
		;MOVT r6, #0x4003;base 0x40030000
		ldr r6,=0x40030000
		;MOVW r7, #0xC
		mov r7,#0xC
	;LDR r1, [r6, r7];base 0x40030000-> 0x4003000C
		ORR r1, #0x1
	;STR r1, [r6, r7] ; go!!
		
Exit 	B Exit
NmiISR 	B NmiISR
FaultISR B FaultISR
IntDefaultHandler
		;MOVW r10, #0xBEEF
		;MOVT r10, #0xDEAD
		ldr r10,=0xDEADBEEF
		bx	lr
		
done 	B done
Get_Match
		STMFD sp!,{r0,r1,r2,r3,lr}
		
		ldr r1,=15000000
		ldr r0,=5
		ldr r3,=0xFFFFFFFF
		mul r2,r1,r0
		sub r2,r3,r2
		
		LDMFD sp!,{r0,r1,r2,r3,pc}	
		ALIGN
		END