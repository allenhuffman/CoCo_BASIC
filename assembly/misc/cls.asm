* lwasm cls.asm -fbasic -ocls.bas --map

* Test of EXEC

ORGADDR equ     $3f00

VIDRAM  equ     $400    VIDEO DISPLAY AREA

    org ORGADDR

clsred
    lda #191    * Red block.
    bsr clear
    rts

clsgreen
    lda #223    * Green block.
    bsr clear
    rts

clsblue
    lda #175    * Blue block
    bsr clear
    rts

clear
    ldx #VIDRAM         * Top left of 32 column screen.
loop
    sta ,x+             * Store at X and increment X.
    cmpx #VIDRAM+512    * Compare X to bottom right of screen
    bne loop
    rts

    end
    