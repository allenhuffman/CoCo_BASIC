* lwasm bigmaze.asm -fbasic -obigmaze.bas --map

    org $3f00

SCREENSTART equ 1024
SCREENEND   equ 1536

COLOR       equ 2
LEFTSLASH   equ (128+16*COLOR+9)
RIGHTSLASH  equ (128+16*COLOR+6)
BLANK       equ 128

LEFTROW1    fcb LEFTSLASH,BLANK
LEFTROW2    fcb BLANK,LEFTSLASH

RIGHTROW1   fcb BLANK,RIGHTSLASH
RIGHTROW2   fcb RIGHTSLASH,BLANK

start
initrandom
    ldy #$A000          * Color BASIC ROM

mainloop
    cmpy #$B000         * Arbitrary spot in ROM.
    beq initrandom      * If there, go to initrandom. 

    ldx #SCREENEND-32*2 * X points to line 14.

printloop
    lda ,y+             * Load byte from ROM.
    bita 1              * Test bit 1.
    beq right           * If set, go to right.
    bsr printleft       * Gosub printleft.
    bra scrollcheck     * Go to scrollcheck.
right
    bsr printright      * Gosub printleft.

scrollcheck
    cmpx #SCREENEND-32  * Is X at start of last line?
    blt printloop       * No, go to printloop.

scroll
    pshs x              * Save X.
    ldx #SCREENSTART+64 * X points to 3rd line.
scrollloop
    ldd ,x++            * Load 2 bytes, inc X by 2.
    std -66,x           * Store 2 bytes at X-66
    cmpx #SCREENEND-1   * Is X at last screen byte?
    blt scrollloop      * No, go to scrollloop.
clear
    lda #BLANK          * Empty block.
    ldb #BLANK          * Empty block. Will make D.
    ldx #SCREENEND-64   * X points to line 14.
clearloop
    std ,x++            * Store 2 empty blocks, inc X by 2.
    cmpx #SCREENEND-1   * IS X at last screen byte?
    blt clearloop       * No, go to clearloop.
    puls x              * Restore X.

    bra mainloop        * Go to mainloop.

quit
    rts                 * Return to BASIC.

printleft
    ldd LEFTROW2        * Load row 2, 2 bytes.
    std 32,x            * Store 2 bytes line below X.
    ldd LEFTROW1        * Load row 1, 2 bytes.
    std ,x++            * Store 2 bytes at X, inc X by 2.
    rts                 * Return.

printright
    ldd RIGHTROW2       * Load row 2, 2 bytes.
    std 32,x            * Store 2 bytes line below X.
    ldd RIGHTROW1       * Load row 1, 2 bytes.
    std ,x++            * Store 2 bytes at X, inc X by 2.
    rts                 * Return.

    end
