    org $3f00

    clr 1024

    clra
    sta 1024
    sta 1025

    ldd #0
    std 1024

    ldd #0
    ldx #1024
    std ,x

start lda #128
    bsr clearA48s
    rts

clear
    lda #96     * A=96 (green space)
clearA
    ldx #1024   * X=1024 (top left of screen)
loop
    sta ,x+     * POKE X,A:X=X+1
    cmpx #1536  * Compare X to 1536 
    bne loop    * If X<>1536, GOTO loop
    rts         * RETURN

clear16
    lda #96     * A=96
    tfr a,b     * B=A (D=A*256+B)
clearA16
    ldx #1024   * X=1024 (top left of screen)
    opt ct,cc   * Clear counter, turn it on.
loop16
    std ,x++    * POKE X,A:POKE X+1,B:X=X+2
    cmpx #1536  * Compare X to 1536
    bne loop16  * If X<>1536, GOTO loop16
    opt noct    * Turn off counter.
    rts         * RETURN

clear32
    lda #96     * A=96
    tfr a,b     * B=A (D=A*256+B)
clearA32
    ldx #1024   * X=1024 (top left of screen)
    opt ct,cc   * Clear counter, turn it on.
loop32
    std ,x++    * POKE X,A:POKE X+1,B:X=X+2
    std ,x++    * POKE X,A:POKE X+1,B:X=X+2
    cmpx #1536  * Compare X to 1536.
    bne loop32  * If X<>1536, GOTO loop32
    opt noct    * Turn off counter.
    rts         * RETURN

clear48
    lda #96     * A=96
    tfr a,b     * B=A (D=A*256+B)
clearA48
    ldx #1024   * X=1024 (top left of screen)
    opt ct,cc   * Clear counter, turn it on.
loop48
    std ,x++    * POKE X,A:POKE X+1,B:X=X+2
    std ,x++    * POKE X,A:POKE X+1,B:X=X+2
    std ,x++    * POKE X,A:POKE X+1,B:X=X+2
    cmpx #1536  * Compare X to 1536.
    bne loop48  * If X<>1536, GOTO loop48
    std ,x      * POKE X,A:POKE X+1,B:X=X+2
    opt noct    * Turn off counter.
    rts         * RETURN

clear64
    lda #96     * A=96
    tfr a,b     * B=A (D=A*256+B)
clearA64
    ldx #1024   * X=1024 (top left of screen)
    opt ct,cc   * Clear counter, turn it on.
loop64
    std ,x++    * POKE X,A:POKE X+1,B:X=X+2
    std ,x++    * POKE X,A:POKE X+1,B:X=X+2
    std ,x++    * POKE X,A:POKE X+1,B:X=X+2
    std ,x++    * POKE X,A:POKE X+1,B:X=X+2
    cmpx #1536  * Compare X to 1536.
    bne loop64  * If X<>1536, GOTO loop64
    opt noct    * Turn off counter.
    rts         * RETURN

clear48s
    lda #96     * A=96
clearA48s
    tfr a,b     * B=A (D=A*256+B)
    tfr d,x     * X=D
    tfr d,y     * Y=D
    ldu #1536   * U=1536 (1 past end of screen)
    opt ct,cc   * Clear counter, turn it on.
loop48s
    pshu d,x,y
    cmpu #1026  * Compare U to 1026 (two bytes from start).
    bgt loop48s * If X<>1026, GOTO loop48s
    pshu d      * Final 2 bytes.
    opt noct    * Turn off counter.
    rts         * RETURN

    END $3f00
