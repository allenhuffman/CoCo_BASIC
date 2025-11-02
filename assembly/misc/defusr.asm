* lwasm defusr.asm -fbasic -odefusr.bas --map

* Test of DEF USR.

ORGADDR equ     $3f00

VIDRAM  equ     $400    VIDEO DISPLAY AREA
CHROUT  EQU     $A002
INTCNV  EQU     $B3ED   * 46061
GIVABF  EQU     $B4F4   * 46324
REGDOUT EQU     $BDCC   * convert the value in ACCD into a decimal number
                        * and send it to CONSOLE OUT.

    org ORGADDR

start
checknumber
    cmpa #0             * 0=number
    beq donumber

    cmpa #255           * 255=string
    beq dostring

    ldx #msgunknown
    bsr print

error
    ldd #-1             * Return -1 as an error code
return
    jmp GIVABF          * Value in reg D will be returned to BASIC.

donumber
    jsr INTCNV          * Load D with number
    jsr REGDOUT         * Display number
    ldd #0              * D=0 (no error code)
    bra return

dostring                * X will be VARPTR
    ldb ,x              * B=string length
    ldy 2,x             * Y=string data address
    beq stringdone
loop
    lda ,y+             * A=byte of string data, increment Y
    jsr [CHROUT]        * Output character in A
    decb                * Decrement B (length of string)
    bne loop            * If not 0, go back to loop
stringdone
    bsr printspace

    tfr x,d             * Transfer X into D register
    jsr printd          * Print VARPTR address
    bsr printspace

    clra                * A=0
    ldb ,x              * B=string len (making D)
    bsr printd          * Print string length
    bsr printspace

    ldd 2,X             * Load D with string address
    bsr printd          * Print the number

    ldd #0              * D=0 (no error code)
    bra return

* PRINT integer in D
printd
    pshs a,b,x,u
    jsr REGDOUT
    puls a,b,x,u
    rts

* PRINT space
printspace
    pshs a
    lda #32
    jsr [CHROUT]
    puls a
    rts

* PRINT subroutine. Prints the string pointed to by X.
print
    lda ,x+
    beq printdone
    jsr [CHROUT]
    bra print
printdone
    lda #13
    jsr [CHROUT]
    rts

msgunknown
    fcc "UNKNOWN"
    fcb 0

    end
    