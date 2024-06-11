		AREA led,code,readonly
		entry
		
		ldr r1,=0x40000000		;bit banded region base
		ldr r4,=0x42000000		;bit banded alias base
		ldr r5,=7				;bits number
		
		ldr r0,=0x43070010		;(1)
		
		sub r0,r0,r4			;byte offset
		lsr r6,r0,#5			;offset /32
		ldr r7,=0xFFFFFF00
		bic r0,r0,r7			;last 8 bits
		lsr r0,#2				;bit number=last 8 bits/4
		
		add r6,r6,r1			;bit banded region 0x40083800
		
		ldr r0,=0x43070010		;(2)
		
		ldr r7,=0x1FF0000
		and r6,r0,r7
		ror r6,#5
		and r7,#0xFF
		ror r7,#2
		
		orr r6,r6,r1			;bit banded region
		
		;ldr r8,=0x40038000
		;ldr r0,[r8]
		ldr r0,=0x40038000		;(3)alias(a)
		ldr r1,=0x40000000
		ldr r6,=0x42000000		;bit banded alias base
		ldr r5,=12
		
		sub r0,r0,r1
		lsl r0,#5
		ldr r7,=0xFFFFFF00
		lsl r8,r5,#2
		add r6,r0
		add r6,r8;0x42700030
		
		ldr r0,=0x40038000		;(b)
		ldr r6,=0x42000000
		ldr r7,=0xFF000
		and r6,r0,r7
		ror r6,#27
		ror r8,r5,#30
		orr r6,r4
		orr r6,r8
		
		ldr r1,=0x42000000
		ldr r2,=0x40038000
		ldr r3,=12
		ldr sp,=0x40000080
		bl Conv2Alias
		
		ldr r1,=0x43070010
		bl Conv2Region	
		
stop	B stop
Conv2Alias
		stmdb sp!,{r8,r9,r10,lr}
		lsl r3,#2
		
		ldr r9,=0x40000000
		sub r2,r9
		lsl r2,#5
		
		add r1,r3
		add r1,r2
		ldmia sp!,{r8,r9,r10,pc}
		
Conv2Region	
		stmdb sp!,{r8,r9,r10,lr}
		ldr r9,=0x42000000
		ldr r10,=0x40000000
		sub r1,r9				;byte offset
		lsr r6,r1,#5			;offset /32
		ldr r7,=0xFFFFFF00
		bic r2,r1,r7			;last 8 bits
		lsr r2,#2				;bit number=last 8 bits/4
		
		add r3,r10,r6			;bit banded region 0x40083800
		ldmia sp!,{r8,r9,r10,pc}
		
		END