        AREA    RESET, DATA, READONLY
        EXPORT  __Vectors
        EXPORT  Reset_Handler

__Vectors       DCD     __initial_sp              ; Initial Stack Pointer
                DCD     Reset_Handler             ; Reset Handler
                DCD     NmiISR                    ; NMI Handler
                DCD     FaultISR                  ; Hard Fault Handler
                DCD     IntDefaultHandler         ; Default Interrupt Handler

        AREA    test2, CODE, READONLY
        THUMB

Reset_Handler
        LDR     r0, =__initial_sp
        MOV     sp, r0
        BL      main
        B       .

main
        ; ?? TIMER0
        ldr     r0, =0x400FE000
        MOV     r2, #0x60
        ldr     r1, =0x54001C0
        STR     r1, [r0, r2]

        ; ?? TIMER0 ???
        MOVW    r7, #0x604
        LDR     r1, [r0, r7]
        ORR     r1, #0x1
        STR     r1, [r0, r7]

        NOP
        NOP
        NOP
        NOP
        NOP

        ; ?? TIMER0 ? one-shot ??
        MOVW    r8, #0x0000
        MOVT    r8, #0x4003
        MOVW    r7, #0x4
        LDR     r1, [r8, r7]
        ORR     r1, #0x21
        STR     r1, [r8, r7]

        LDR     r1, [r8]
        ORR     r1, #0x4
        STR     r1, [r8]

        ; ?????
        ldr     r0, =0x40000000   ; ???
        movw    r1, #0x973F       ; ????16?
        movt    r1, #0xFB87       ; ????16?
        movw    r2, #0x30         ; ???
        str     r1, [r0, r2]      ; ??????????

        ; ?? GPTM ????????
        MOVW    r7, #0x18
        LDR     r1, [r8, r7]
        ORR     r1, #0x10
        STR     r1, [r8, r7]

        ; ?? TIMER0 ??
        MOVW    r6, #0xE000
        MOVT    r6, #0xE000
        MOVW    r7, #0x100
        MOV     r1, #(1<<19)
        STR     r1, [r6, r7]

        ; ?? TIMER
        MOVW    r6, #0x0000
        MOVT    r6, #0x4003
        MOVW    r7, #0xC
        LDR     r1, [r6, r7]
        ORR     r1, #0x1
        STR     r1, [r6, r7]

        B       done

NmiISR
        B       NmiISR

FaultISR
        B       FaultISR

IntDefaultHandler
        MOVW    r10, #0xBEFF
        MOVT    r10, #0xDEAD
        B       Spot

Spot    
        B       Spot    

done    
        B       done

        AREA    STACK, NOINIT, READWRITE
        EXPORT  __initial_sp
__initial_sp    SPACE   0x400

        END
