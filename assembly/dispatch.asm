; lwasm dispatch.asm -fbasic -odispatch.bas --map
; a09 -fbasic -odispatch.bas dispatch.asm

ORGADDR     equ     $3f00       ; Where program loads in memory

            org     ORGADDR

;------------------------------------------------------------------------------
; Absolute addresses of ROM calls
;------------------------------------------------------------------------------
CHROUT      equ	    $A002

;------------------------------------------------------------------------------
; This code can be called by EXEC/EXEC xxxx.
;------------------------------------------------------------------------------
; Dispatch table at the start of the program.
start1      bra     install
start2      bra     uninstall

install     leax    <msginst,pcr    ; X points to message
            bra     print           ; print will do the RTS
            ;rts

uninstall   leax    <msguninst,pcr  ; X points to message
            ;bra     print          ; print will do the RTS
            ;rts

;------------------------------------------------------------------------------
; PRINT subroutine. Prints the 0-terminated string pointed to by X plus CR
;------------------------------------------------------------------------------
print       lda     ,x+
            beq     printdone
            jsr     [CHROUT]
            bra     print
printdone   lda     #13
            jmp     [CHROUT]        ; JMP CHROUT will do an rts.
            ;rts

;------------------------------------------------------------------------------
; Data storage for the string messages
;------------------------------------------------------------------------------
msginst     fcc     "INSTALLED"
            fcb     0

msguninst   fcc     "UNINSTALLED"
            fcb     0

            end
