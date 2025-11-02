
    org $3f00

SCREENSTART equ 1024
SCREENEND   equ 1535

start
    bsr clearscreen





    rts

showmaze

    rts

clearscreen
    lda #128
clearcolor
    tfr a,b
    ldx #SCREENSTART
clearloop
    std ,x++
    cmpx #SCREENEND
    ble clearloop
    rts

    END

mazewidth   fcb 40
mazeheight  fcb 25
mazedata
    fcc "+--------------------------------------+"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "!                                      !"
    fcc "+--------------------------------------+"

* Variables

DRAWX   rmb 1
DRAWY   rmb 1
