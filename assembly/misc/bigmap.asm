* bigmap.asm

    org $3f00

POLCAT      equ $a000

UPKEY       equ $5e
DOWNKEY     equ $0a
LEFTKEY     equ $08
RIGHTKEY    equ $09
CLEARKEY    equ $0c
BREAKKEY    equ $03

KEYBUF      equ $152    * 8 bytes.

SCREENSTART equ 1024
SCREENEND   equ 1536
SCREENW     equ 32
SCREENH     equ 16

start
    *lbsr cls
    *lbsr waitforkey

    ldx #LEVELDATA
    stx STARTL
    
    lda #0
    sta STARTX
    
    lda #0
    sta STARTY
    
    lda LEVELW
    suba #SCREENW
    sta MAXX

    lda LEVELH
    suba #SCREENH
    sta MAXY

mainloop
    lbsr drawmap

inkey
    * Reset rollover table for key repeat.
    ldd #$ffff
    std KEYBUF
    std KEYBUF+2
    std KEYBUF+4
    std KEYBUF+6

    jsr [POLCAT]
    beq inkey

    cmpa #UPKEY
    beq up

    cmpa #DOWNKEY
    beq down

    cmpa #LEFTKEY
    beq left

    cmpa #RIGHTKEY
    beq right

    cmpa #BREAKKEY
    beq return

    bra inkey

up
    lda STARTY
    cmpa MAXY
    bge updone
    inc STARTY

    ldx STARTL      * X=STARTL
    ldb LEVELW     * B=40
    ;abx             * X=X+B
    leax b,x        * X=X+B
    stx STARTL      * STARTL=X
updone
    bra inkeydone   * GOTO inkeydone

down
    lda STARTY      * A=STARTY
    beq downdone    * if A=0, GOTO updone.
    dec STARTY      * STARTY=STARTY-1

    ldx STARTL      * X=STARTL
    ldb LEVELW      * B=40
    negb            * B=0-B
    leax b,x        * X=X+B
    stx STARTL      * STARTL=X
downdone
    bra inkeydone   * GOTO inkeydone

left
    lda STARTX      * A=STARTX
    cmpa MAXX       * Compare A to MAXX.
    bge leftdone    * if A>=MAXY, GOTO updone.
    inc STARTX      * STARTX=STARTX+1

    ldx STARTL
    leax 1,x
    stx STARTL
leftdone
    bra inkeydone

right
    lda STARTX      * A=STARTX
    beq rightdone   * if A=0, GOTO updone.
    dec STARTX      * STARTX=STARTX-1

    ldx STARTL
    leax -1,x
    stx STARTL
rightdone
    bra inkeydone

inkeydone
    lbra mainloop

return
    rts


*----------------------------------------------------------------------------
drawmap
    lda #SCREENH
    sta COUNTERY
    ldx STARTL
    ldy #SCREENSTART
    sync

drawstart
    lda #SCREENW
    sta COUNTERX
    pshs x
drawloop
    ldd ,x++
    std ,y++
    dec COUNTERX
    dec COUNTERX    
    beq nextline
    bra drawloop
nextline
    puls x
    lda LEVELW
    leax a,x
    dec COUNTERY
    bne drawstart
    rts

waitforkey
    jsr [POLCAT]
    beq waitforkey
    rts

cls
    lda #128
clsA
    tfr a,b
    ldx #SCREENSTART
clsloop
    std ,x++
    cmpx #SCREENEND
    blt clsloop
    rts

STARTL      rmb 2
STARTX      rmb 1
STARTY      rmb 1
MAXX        rmb 1
MAXY        rmb 1
COUNTERX    rmb 1
COUNTERY    rmb 1

LEVELW      fcb 64
LEVELH      fcb 31
LEVELDATA
    *   "---------1---------2---------3---------4---------5---------6----"
    fcc "XXXXXXXXXXXXXXXXXXXXXXXXXXXX        XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    fcc "X            XX            X        X                          X"
    fcc "X XXXX XXXXX XX XXXXX XXXX X        X                          X"
    fcc "X X  X X   X XX X   X X  X X        X                          X"
    fcc "X XXXX XXXXX XX XXXXX XXXX X        X                          X"
    fcc "X                          X        X                          X"
    fcc "X XXXX XX XXXXXXXX XX XXXX X        X                          X"
    fcc "X XXXX XX XXXXXXXX XX XXXX X        X                          X"
    fcc "X      XX    XX    XX      X        X                          X"
    fcc "XXXXXX XXXXX XX XXXXX XXXXXX        X                          X"
    fcc "     X XXXXX XX XXXXX X             X                          X"
    fcc "     X XX          XX X             X                          X"
    fcc "     X XX XXX--XXX XX X             X                          X"
    fcc "XXXXXX XX X      X XX XXXXXXXXXXXXXXX                          X"
    fcc "          X      X                                             X"
    fcc "XXXXXX XX X      X XX XXXXXXXXXXXXXXX                          X"
    fcc "     X XX XXXXXXXX XX X             X                          X"
    fcc "     X XX          XX X             X                          X"
    fcc "     X XX XXXXXXXX XX X             X                          X"
    fcc "XXXXXX XX XXXXXXXX XX XXXXXX        X                          X"
    fcc "X            XX            X        X                          X"
    fcc "X XXXX XXXXX XX XXXXX XXXX X        X                          X"
    fcc "X XXXX XXXXX XX XXXXX XXXX X        X                          X"
    fcc "X   XX                XX   X        X                          X"
    fcc "XXX XX XX XXXXXXXX XX XX XXX        X                          X"
    fcc "XXX XX XX XXXXXXXX XX XX XXX        X                          X"
    fcc "X      XX    XX    XX      X        X                          X"
    fcc "X XXXXXXXXXX XX XXXXXXXXXX X        X                          X"
    fcc "X XXXXXXXXXX XX XXXXXXXXXX X        X                          X"
    fcc "X                          X        X                          X"
    fcc "XXXXXXXXXXXXXXXXXXXXXXXXXXXX        XXXXXXXXXXXXXXXXXXXXXXXXXXXX"

    end
