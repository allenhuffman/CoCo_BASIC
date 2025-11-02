* lwasm 10printasm.asm -fbasic -o10printasm.bas --map

    org $3f00

start
    ldy #$A000          * Color BASIC ROM

mainloop
    cmpy #$B000         * Arbitrary spot in ROM.
    beq start           * If there, GOTO start.
    lda #'/             * A="/"
    tst ,y+             * Test NEG bit (high bit).
    bmi print           * Branch if NEG set.
    lda #'\             * A="\"
print
    jsr [$a002]         * Print what is in A.
    bra mainloop        * GOTO mainloop.

    END
