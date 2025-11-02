* lwasm attract32.asm -fbasic -oattract32.bas --map

    org $3f00

start
    ldx #1024   X points to top left of 32-col screen
loop
    lda ,x+     load A with what X points to and inc X
    bpl skip    if not >128, skip
    adda #16    add 16, changing to next color
    ora #$80    make sure high gfx bit is set
    sta -1,x    save at X-1
skip
    cmpx #1536  compare X with last byte of screen
    bne loop    if not there, repeat
    sync        wait for screen sync
    rts         done

    END
