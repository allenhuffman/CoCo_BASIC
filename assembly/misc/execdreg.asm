; lwasm execdreg.asm -fbasic -oexecdreg.bas --map
; decb copy -2 execdreg.bin drive0.dsk,EXECDREG.BIN

; Show if routine is being called with USRx(n) or EXEC

ORGADDR     equ     $3e00       ; Where program loads in memory.

; Absolute addresses of ROM calls.
CHROUT      equ	    $A002
INTCNV      equ     $B3ED
GIVABF      equ     $B4F4

            org     ORGADDR

; This code expects to have been called by USRx(x) or EXEC xxxx.
start       cmpd    #0          ; called from EXEC?
            beq     fromexec    ; if yes, goto fromexec
fromusr     jsr     INTCNV      ; else, get USR number parameter in D
            pshs    d           ; save D
            leax    usrmsg,pcr  ; display "called from USR" message
            bsr     print
            puls    d           ; restore D
            addd    #1          ; add one to D
            jmp     GIVABF      ; return back to USR call.

fromexec    leax    execmsg,pcr ; display "called from EXEC" message
            bsr     print
            rts

; PRINT subroutine. Prints the 0-terminated string pointed to by X plus CR.
print       lda     ,x+
            beq     printdone
            jsr     [CHROUT]
            bra     print
printdone   lda     #13
            jsr     [CHROUT]
            rts

usrmsg      fcc     "CALLED FROM USR"
            fcb     0

execmsg     fcc     "CALLED FROM EXEC"
            fcb     0

            end
