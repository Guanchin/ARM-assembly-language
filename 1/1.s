		AREA led,code,readonly
		entry
		; Set sysclk to DIV/4, use PLL, XTAL_16 MHz, OSC_MAIN
		; system control base is 0x400FE000, offset 0x60
		; bits[26:23]= 0x3
		; bit[22] = 0x1
		; bit[13] = 0x0
		; bit[11] = 0x0
		; bits[10:6] = 0x15
		; bits[5:4] = 0x0
		; bit[0] = 0x0
		; This all translates to a value of 0x01C00540
		;MOVW r0, #0xE000
		;MOVT r0, #0x400F
		ldr r0,=0x400FE00
		;MOVW r2, #0x60 ; offset 0x60 for this register
		MOV r2, #0x60
		;MOVW r1, #0x0540
		;MOVT r1, #0x01C0;
		ldr r1,=0x1c00540
		STR r1, [r0, r2] ; write the registerís contents
		; Enable GPIOF
		; RCGCGPIO (page 339)
		;MOVW r2, #0x608 ; offset for this register
		ldr r2,=0x608
	;LDR r1, [r0, r2] ; grab the register contents
		ORR r1, r1, #0x20 ; enable GPIOF clock,port line F(PF)
	;STR r1, [r0, r2]
		
		; Set the direction using GPIODIR (page 661)
		; Base is 0x40025000
		;MOVW r0, #0x5000
		;MOVT r0, #0x4002
		ldr r0,=0x40025000
		
		;MOVW r2, #0x400 ; offset for this register
		ldr r2,=0x400
	;ldr r3,[r0,r2];read
		ldr r1, =0x111;0000 bgr0=0x0000 1110
		orr r3,r1;modify
	;STR r3, [r0, r2] ; set 1 or 2 or 3 for output,write,0x40025000,str 0xE
		
		;set the GPIODEN lines
		;MOVW r2, #0x51c ; offset for this register
		ldr r2,=0x51c
	;ldr r3,[r0,r2];read
		orr r3,r1;modify
	;STR r3, [r0, r2] ; set 1 and 2 and 3 for I/O,write
		;-----------------------------
		ldr r0,=0x40000000
		SUB r7, r7, r7 ; clear out r7
		ldr r6, =0x100 ; start with LED = 0b10
		;0b00000010 red,0b00000100 green,0b00001000 blue,
mainloop
		; turn on the LED
		; if bits [9:2] affect the writes, then the address
		; is offset by 0x38
		STR r6, [r0, #0x38] ; base + 0x38 so [9:2] = 0b00111000
		;MOVT r7, #0xF4 ; set counter to 0xF40000,delay=0xF40000*2Clock Cycles/16MHZ
		tst r5,#1
		beq RGB
		bne BGR
RGB		
		; change colors
		CMP r6, #1;3.99769794,~=8M Hz
		;ITE LT
		LSRGT r6, r6, #4 ; LED = LED * 2
		ADDLE r5, #1 ; reset to 2 otherwise
		B out
BGR		
		; change colors
		ldr r7,=0x100
		CMP r6,r7;3.99769794,~=8M Hz
		;ITE GT
		LSLLT r6, r6, #4 ; LED = LED * 2
		ADDGE r5, #1 ; reset to 2 otherwise
		B out
out		
		;0.00000206
		BL DELAY
		
		B mainloop
stop	B stop
DELAY
		ldr r7,=0x895440;3M
spin
		SUBS r7, r7, #1
		BNE spin
		bx lr
		END