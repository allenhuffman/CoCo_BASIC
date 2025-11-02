* lwasm defusr2.asm -fbasic -odefusr2.bas --map

* Test of DEF USR.

ORGADDR equ     $3f00

INTCNV  EQU     $B3ED   * 46061
GIVABF  EQU     $B4F4   * 46324

    org ORGADDR

start
    beq donumber        * If A=0, number passed in.
    inca                * Increment A, so if 255 (string), it will be 0 now.
    beq dostring        * If A was 255, string passed in.
error
    ldd #-1             * Return -1 as an error code
    bra return

donumber
    jsr INTCNV          * Load D with number
    * Insert your code here...
    addd #1             * Add 1 to D.
    bra return

dostring                * X will be VARPTER, B will be string length.
    ldy 2,x             * Y=string data address.
    beq stringdone
loop
    lda ,y+             * A=byte of string data, increment Y
    jsr [CHROUT]        * Output character in A
    decb                * Decrement B (length of string)
    bne loop            * If not 0, go back to loop

noerror
    ldd #0              * D=0 (no error code)
return
    jmp GIVABF

    end
    