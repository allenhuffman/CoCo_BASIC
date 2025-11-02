; lwasm execdreg2.asm -fbasic -oexecdreg2.bas --map
; decb copy -2 execdreg2.bin drive0.dsk,EXECDRG2.BIN

; Show if USR is being called with a number or a string.

ORGADDR     equ     $3e00   ; Where program loads in memory.

; Absolute addresses of ROM calls.
CHROUT      equ	    $A002
INTCNV      equ     $B3ED
GIVABF      equ     $B4F4

            org     ORGADDR

; This code expects to have been called by USRx(x) or USRx("STRING")
start       tsta                    ; A=0 is USR(0), A=255 is USR("...")
            bne     usrstring       ; if not 0, goto usrstring
usrnumber   pshs    d,x             ; save D and X
            leax    numbermsg,pcr   ; display "number" message
            bsr     print
            puls    d,x             ; restore D and X
            jsr     INTCNV          ; else, get USR number parameter in D
            addd    #1              ; add one to D
            jmp     GIVABF          ; return back to USR call.

usrstring   leax    stringmsg,pcr   ; display "string" message
            bsr     print
            ldd     #123            ; load D with return value
            jmp     GIVABF          ; return back to USR call.

; PRINT subroutine. Prints the 0-terminated string pointed to by X plus CR.
print       lda     ,x+
            beq     printdone
            jsr     [CHROUT]
            bra     print
printdone   lda     #13
            jsr     [CHROUT]
            rts

stringmsg   fcc     "STRING"
            fcb     0

numbermsg   fcc     "NUMBER"
            fcb     0

            end
