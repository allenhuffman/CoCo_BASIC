; lwasm whocalled.asm -fbasic -owhocalled.bas --map
; decb copy -2 whocalled.bin drive0.dsk,WHOCALLD.BIN

ORGADDR     equ     $3e00       ; Where program loads in memory.

; Absolute addresses of items in RAM variables.
EXECJP      equ     $9d         location of jump address for EXEC

; Absolute addresses of ROM calls.
CHROUT      equ	    $A002

            org     ORGADDR

; This code expects to have been called by USRx(x).
start       cmpx	#start      ; called by "EXEC xxxx"?
            beq     fromexec    ; if yes, goto fromexec
            cmpx    #$abab      ; called by "EXEC"?
            bne     fromusr     ; if no, must be USR. goto fromusr
            ldx     EXECJP      ; get EXEC address
            cmpx	#start      ; called by "EXEC xxxx"?
            beq     fromexec    ; if yes, goto from exec
fromusr     leax    usrmsg,pcr
            lbsr    print
            rts
fromexec    leax    execmsg,pcr
            lbsr    print
            rts

; PRINT subroutine. Prints the 0-terminated string pointed to by X plus CR.
print       lda     ,x+
            beq     printdone
            jsr     [CHROUT]
            bra     print
printdone   lda     #13
            jsr     [CHROUT]
            rts

usrmsg      fcc     "FROM USR"
            fcb     0

execmsg     fcc     "FROM EXEC"
            fcb     0

            end
