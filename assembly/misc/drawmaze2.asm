* lwasm drawmaze2.asm -fbasic -odrawmaze2.bas

    org $3f00

SCREENSTART equ 1024    * SCRENSTART=1024
SCREENEND   equ 1535    * SCREENEND=1535

start
    bsr initmaze        * GOSUB initmaze
    bsr drawmaze        * GOSUB drawmaze
    rts                 * RETURN

drawmaze
    ldx #MAZEBUFFER     * X=MAZEBUFFER
drawstart
    pshs x              * Save X
    ldy #SCREENSTART    * Y=SCREENSTART
drawloop
    ldd ,x++            * A=PEEK(X):B=PEEK(X+1):X=X+2
    std ,y++            * POKE Y,A:POKE Y+1,B:Y=Y+2
    cmpy #SCREENEND     * Compare Y to SCREENEND
    blt drawloop        * if Y<SCREENEND, GOTO drawloop
    puls x              * Restore X

getkey
    pshs x
getkeyloop
    jsr [$a000]
    beq getkeyloop
    puls x
    cmpa #94
    beq up
    cmpa #10
    beq down
    cmpa #3
    beq keyreturn
    bra getkey

up
    cmpx #MAZEBUFFEREND-512
    bge continue
    leax 32,x
    bra continue

down
    cmpx #MAZEBUFFER
    beq continue
    leax -32,x
continue
    bra drawstart

keyreturn
    rts                 * RETURN

initmaze
    ldx #MAZEBUFFER
clearbuffer
    clr ,x+
    cmpx #MAZEBUFFEREND
    bne clearbuffer

    ldx #pacmaze        * X=pacmaze
    ldy #MAZEBUFFER     * Y=MAZEBUFFER
    
    ldb pacmazew        * B=pacmazew value.
    clra                * A=0
countbytes
    inca                * A=A+1
    subb #8             * B=B-8
    bhi countbytes      * if B>0, GOTO countbytes
    sta BYTESPERROW     * BYTESPERROW=A
    ldb pacmazeh        * B=pacmazew value.
    mul                 * D=A*B
    stb TOTALBYTES      * TOTALBYTES=B (WARNING! 0-255 only.)

drawrow
    pshs y              * Save Y (start of current row)
    lda BYTESPERROW     * A=BYTESPERROW
    sta BYTESLEFT       * BYTESLEFT=A
getbyte
    lda #8              * A=8
    sta BITSLEFT        * BITSLEFT=A
    lda ,x+             * A=PEEK(X). X=X+1
getbit
    lsla                * A=A*2 (logical shift left)
    bcc zero            * If left bit was 0, GOTO zero
one
    ldb #175            * B=175 (blue block)
    bra store           * GOTO store
zero
    ldb #128            * B=128 (black block)
store
    stb ,y+             * POKE Y,B:Y=Y+1
    cmpy #MAZEBUFFEREND * Compare Y to MAZEBUFFEREND
    bgt cleanup         * if Y>SCREENEND then GOTO cleanup
    dec BITSLEFT        * BITSLEFT=BITSLEFT-1
    bne getbit          * if BITSLEFT<>0, GOTO getbit
    dec BYTESLEFT       * BYTESLEFT=BYTESLEFT-1
    bne getbyte         * if BYTESLEFT<>0, GOTO getbyte

newrow
    puls y              * Restore Y
    dec TOTALBYTES      * TOTALBYTES=TOTALBYTES-1
    beq return          * if TOTALBYTES=0, GOTO return

    leay 32,y           * Y=Y+32
    cmpy #MAZEBUFFEREND * Compare Y to SCREENEND
    blt drawrow         * if Y<SCREENEND, GOTO drawrow
    bra return          * GOTO return

cleanup
    puls y              * Restore Y

return
    * MODIFY MAZE HERE!

    rts                 * Return

inkey pshs a,b,x,Y
loop jsr [$a000]
 beq loop
 cmpa #3
 beq quit
 puls a,b,x,y,pc
quit
 puls a,b,x,y
 leas 2,s
 rts


    * 28x30 tiles
pacmazew
    fcb 28
pacmazeh
    fcb 31
pacmaze
    fcb $FF,$FF,$FF,$F0
    fcb $80,$06,$00,$10
    fcb $BD,$F6,$FB,$D0
    fcb $BD,$F6,$FB,$D0
    fcb $BD,$F6,$FB,$D0
    fcb $80,$00,$00,$10
    fcb $BD,$BF,$DB,$D0
    fcb $BD,$BF,$DB,$D0
    fcb $81,$86,$18,$10
    fcb $FD,$F6,$FB,$F0
    fcb $05,$F6,$FA,$00
    fcb $05,$80,$1A,$00
    fcb $05,$BF,$DA,$00
    fcb $FD,$A0,$5B,$F0
    fcb $00,$20,$40,$00
    fcb $FD,$A0,$5B,$F0
    fcb $05,$BF,$DA,$00
    fcb $05,$80,$1A,$00
    fcb $05,$BF,$DA,$00
    fcb $FD,$BF,$DB,$F0
    fcb $80,$06,$00,$10
    fcb $BD,$F6,$FB,$D0
    fcb $BD,$F6,$FB,$D0
    fcb $8C,$00,$03,$10
    fcb $ED,$BF,$DB,$70
    fcb $ED,$BF,$DB,$70
    fcb $81,$86,$18,$10
    fcb $BF,$F6,$FF,$D0
    fcb $BF,$F6,$FF,$D0
    fcb $80,$00,$00,$10
    fcb $FF,$FF,$FF,$F0
    ; BINARY (you can see the maze in this sorta)
    ; fcb %11111111,%11111111,%11111111,%11110000
    ; fcb %10000000,%00000110,%00000000,%00010000
    ; fcb %10111101,%11110110,%11111011,%11010000
    ; fcb %10100101,%00010110,%10001010,%01010000
    ; fcb %10111101,%11110110,%11111011,%11010000
    ; fcb %10000000,%00000000,%00000000,%00010000
    ; fcb %10111101,%10111111,%11011011,%11010000
    ; fcb %10111101,%10111111,%11011011,%11010000
    ; fcb %10000001,%10000110,%00011000,%00010000
    ; fcb %11111101,%11110110,%11111011,%11110000
    ; fcb %00000101,%11110110,%11111010,%00000000
    ; fcb %00000101,%10000000,%00011010,%00000000
    ; fcb %00000101,%10111001,%11011010,%00000000
    ; fcb %11111101,%10100000,%01011011,%11110000
    ; fcb %00000000,%00100000,%01000000,%00000000
    ; fcb %11111101,%10100000,%01011011,%11110000
    ; fcb %00000101,%10111111,%11011010,%00000000
    ; fcb %00000101,%10000000,%00011010,%00000000
    ; fcb %00000101,%10111111,%11011010,%00000000
    ; fcb %11111101,%10111111,%11011011,%11110000
    ; fcb %10000000,%00000110,%00000000,%00010000
    ; fcb %10111101,%11110110,%11111011,%11010000
    ; fcb %10111101,%11110110,%11111011,%11010000
    ; fcb %10001100,%00000000,%00000011,%00010000
    ; fcb %11101101,%10111111,%11011011,%01110000
    ; fcb %11101101,%10111111,%11011011,%01110000
    ; fcb %10000001,%10000110,%00011000,%00010000
    ; fcb %10111111,%11110110,%11111111,%11010000
    ; fcb %10111111,%11110110,%11111111,%11010000
    ; fcb %10000000,%00000000,%00000000,%00010000
    ; fcb %11111111,%11111111,%11111111,%11110000

TOTALBYTES rmb 1
BYTESPERROW rmb 1
BYTESLEFT rmb 1
BITSLEFT rmb 1
COLUMN rmb 1
ROW rmb 1

* Hard-coded for now.
MAZEBUFFER rmb 32*31
MAZEBUFFEREND
MAZEBUFFERSIZE equ *-MAZEBUFFER

    end     $3f00
