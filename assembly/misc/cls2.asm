* lwasm cls2.asm -fbasic -ocls2.bas --map

* Test of EXEC

ORGADDR equ     $3f00

VIDRAM  equ     $400    VIDEO DISPLAY AREA

    org ORGADDR

clsred bra clearred
clsgreen bra cleargreen
clsblue bra clearblue

clearred
    lda #191    * Red block.
    bsr clear
    rts

cleargreen
    lda #223    * Green block.
    bsr clear
    rts

clearblue
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
    