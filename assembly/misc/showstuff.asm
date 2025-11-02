; lwasm showstuff.asm -fbasic -oshowstuff.bas --map
; decb copy -2 showstuff.bin drive0.dsk,SHOWSTUF.BIN

ORGADDR     equ     $3e00       ; Where program loads in memory.

; Absolute addresses of items in RAM variables.
EXECJP      equ     $9d         location of jump address for EXEC

; Absolute addresses of ROM calls.
REGDOUT     EQU     $BDCC       ; Convert the value in ACCD into a decimal
                                ; number and send it to CONSOLE OUT.

            org     ORGADDR

start       tfr     x,d         ; X=D
            jsr     REGDOUT
            lda     #32         ; space
            jsr     [CHROUT]
            ldd     EXECJP      ; load D with EXEC address
            jsr     REGDOUT
            rts

            end
