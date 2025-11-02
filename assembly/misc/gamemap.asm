* lwasm gamemap.asm -fbasic -ogamemap.bas --map

* Constants.
SCREENSTART equ 1024
SCREENEND   equ 1535
SCREENWIDTH equ 32
SCREENHEIGHT equ 16

* ROM subroutines.
POLCAT      equ $a000
CHROUT      equ $a002

    org $3f00
    bra start

* Variables
MAXX        rmb 1
MAXY        rmb 1
COPYSTART   rmb 2
COLSTOCOPY  rmb 1
ROWSTOCOPY  rmb 1

start
    lda #42                 a = 42
    lbsr clschar            gosub clschar
    bsr inkey               gosub inkey

    * Init some stuff.
initwidth
    lda level1width         a = level width
    cmpa #SCREENWIDTH       Compare a to screen width.
    ble initheight          if a <= screen width, goto initheight.
    sbca #SCREENWIDTH       a = SCREENWIDTH - a
    sta MAXX                MAXX = a
initheight
    lda level1height        a = level height
    cmpa #SCREENHEIGHT      Compare a to screen height.
    ble initdone            if a <= screen height, goto initdone.
    sbca #SCREENHEIGHT      a = SCREENHEIGHT - a
    sta MAXY                MAXY = a
initdone

    clra
    clrb
loop
    bsr drawscreen          gosub drawscreen
    bsr inkey               gosub inkey
    inca
    cmpa #8
    blt loop

    rts                     Return to BASIC.

* Subroutines

* A=X, B=Y
drawscreen
    pshs a,b
    cmpa MAXX               Compare a to MAXX.
    bgt drawdone            if a >= MAXX, goto drawdone.
    cmpb MAXY               Compare b to MAXY.
    bgt drawdone            if b >= MAXY, goto drawdone.

    ldX #level1data         X points to level1data.
    pshs a,b                Save a and b.
    lda level1width         a = level1width
    mul                     d = a * b
    leaX d,X                X = X + d
    puls a,b                Restore a and b.
    leaX a,X                X = X + a
    stX COPYSTART           COPYSTART = X

    ldy #SCREENSTART        y = screen start
    ldb #SCREENHEIGHT       b = SCREENHEIGHT
    stb ROWSTOCOPY          ROWSTOCOPY = b
copyrow
    lda #SCREENWIDTH        a = SCREENWIDTH
    sta COLSTOCOPY          COLSTOCOPY = a
copyloop
    ldd ,X++                b = *X and X = X + 2
    std ,y++                *y = b and y = y + 2
    dec COLSTOCOPY          COLSTOCOPY = COLSTOCOPY - 1
    dec COLSTOCOPY          COLSTOCOPY = COLSTOCOPY - 1
    bne copyloop            if COLSTOCOPY != 0, goto copyloop.

    dec ROWSTOCOPY          ROWSTOCOPY = ROWSTOCOPY - 1
    beq drawdone            if ROWSTOCOPY = 0, goto drawdone.

    *bsr inkey

    * Move to neXt row of level data.

    ldX COPYSTART           X = COPYSTART
    lda level1width         a = level1width
    leaX a,X                X = X + a
    stX COPYSTART           COPYSTART = X

    bra copyrow

drawdone
    puls a,b
    rts

inkey
    pshs a,b,x,y
inkeyloop
    jsr [POLCAT]
    tsta
    beq inkeyloop
    puls a,b,x,y
    rts

cls
    lda #96
clschar
    tfr a,b
    ldX #SCREENSTART
clsloop
    std ,X++
    cmpX #SCREENEND
    blt clsloop
    rts

* 40 X 25 (C64 sceen siXe)
level1width
    fcb 40
level1height
    fcb 25
level1data
    fcc "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    fcc "X                                      X"
    fcc "X  XXX X X XX     XXX XXX X X  X   XX  X"
    fcc "X  X   X X X X    X    X  X X X X  XX  X"
    fcc "X  XXX X X XX  XX XX   X  XXX XXX  XX  X"
    fcc "X    X X X X X    X    X  X X X X      X"
    fcc "X  XXX XXX XX     XXX  X  X X X X  XX  X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "X                                      X"
    fcc "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    fcb 0

    end
