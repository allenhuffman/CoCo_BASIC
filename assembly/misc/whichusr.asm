; lwasm whichusr.asm -fbasic -owhichusr.bas --map
; decb copy -2 whichusr.bin drive0.dsk,WHICHUSR.BIN

ORGADDR     equ     $3e00   ; Where program loads in memory.

; Absolute addresses of ROM calls.
CHROUT      equ	    $A002
INTCNV      equ     $B3ED
GIVABF      equ     $B4F4

            org     ORGADDR

; This code expects to have been called by USRx(x).
start       beq     donumber    ; if A=0, number passed in. goto donumber.
            inca                ; inc A so if 255 (string) it will be 0 now.
            beq     dostring    ; if A=0 (was 255), string. goto dostring.
            bra     unknown     ; else, goto unknown (this should never happen).

; X will be VARPTER, B will be string length.
dostring    leax    stringmsg,pcr
            bsr     print
            ldd     #0          ; D=0
            jmp     GIVABF      ; return to USR

donumber    pshs    d,x         ; save D and X
            leax    numbermsg,pcr ; display message
            bsr     print
            puls    d,x         ; restor D and X
            jsr     INTCNV      ; get passed in value in D
            addd    #1          ; add one to D
            jmp     GIVABF      ; return to USR

unknown     pshs    d,x         ; save D and X
            leax    unknownmsg,pcr ; display message
            bsr     print
            puls    d,x         ; restor D and X
            jsr     INTCNV      ; get passed in value in D
            addd    #1          ; add one to D
            jmp     GIVABF      ; return to USR

;* PRINT subroutine. Prints the 0-terminated string pointed to by X plus CR.
print       lda     ,x+
            beq     printdone
            jsr     [CHROUT]
            bra     print
printdone   lda     #13
            jsr     [CHROUT]
            rts

numbermsg   fcc     "NUMBER"
            fcb     0

stringmsg   fcc     "STRING"
            fcb     0

unknownmsg   fcc     "UNKNOWN"
            fcb     0

    end
    