; lwasm whocalled2.asm -fbasic -owhocalled2.bas --map
; decb copy -2 whocalled2.bin drive0.dsk,WHOCALL2.BIN

ORGADDR     equ     $3e00       ; Where program loads in memory.

; Absolute addresses of items in RAM variables.
EXECJP      equ     $9d         location of jump address for EXEC

; Absolute addresses of ROM calls.
CHROUT      equ	    $A002
INTCNV      equ     $B3ED
GIVABF      equ     $B4F4

            org     ORGADDR

; This code can be called by USRx(n), USRx("STRING"), EXEC addr or EXEC.
start       cmpx	#start      ; called by "EXEC xxxx"?
            beq     fromexec    ; if yes, goto fromexec
            cmpx    #$abab      ; called by "EXEC"?
            bne     fromusr     ; if no, must be USR. goto fromusr
            ldx     EXECJP      ; get EXEC address
            cmpx	#start      ; called by "EXEC"?
            beq     fromexec    ; if yes, goto from exec
fromusr     tsta                ; A=0?
            beq     donumber    ; if yes, number passed in. goto donumber.
            inca                ; inc A so if 255 (string) it will be 0 now.
            beq     dostring    ; if A=0 (was 255), string. goto dostring.
            bra     unknown     ; else, goto unknown (this should never happen).
            
donumber    leax    numbermsg,pcr ; show "number" message
            bsr     print
            jsr     INTCNV      ; get number that was passed in
            addd    #1          ; add 1 to D
            jmp     GIVABF      ; return new number back to BASIC

dostring    leax    stringmsg,pcr ; show "string" message
            bsr     print
            ldd     #12345      ; load D with a return value
            jmp     GIVABF      ; return that number back to BASIC

fromexec    leax    execmsg,pcr ; show "from exec" message
            lbsr    print
            rts

unknown     leax    unknownmsg,pcr ; this should never happen
            lbsr    print       ; show "unknown" message
            rts

; PRINT subroutine. Prints the 0-terminated string pointed to by X plus CR.
print       lda     ,x+
            beq     printdone
            jsr     [CHROUT]
            bra     print
printdone   lda     #13
            jsr     [CHROUT]
            rts

execmsg     fcc     "FROM EXEC"
            fcb     0

numbermsg   fcc     "FROM USR(NUMBER)"
            fcb     0

stringmsg   fcc     "FROM USR(STRING)"
            fcb     0

unknownmsg  fcc     "UNKNOWN"
            fcb     0

            end
