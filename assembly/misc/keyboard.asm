* lwasm keyboard.asm -fbasic -okeyboard.bas --map

* Conditionals:
;HOLDDOWN    equ 1       * Key repeat
KEEPGOING   equ 1       * Pac-Man style


POLCAT equ $a000

UPKEY       equ $5e
DOWNKEY     equ $0a
LEFTKEY     equ $08
RIGHTKEY    equ $09
CLEARKEY    equ $0c
BREAKKEY    equ $03

KEYBUF      equ $152    * 8 bytes.

SCREENWIDTH     equ 32
SCREENHEIGHT    equ 16
SCREENSTART     equ 1024
ENDOFFIRSTROW   equ 1055
STARTOFLASTROW  equ 1504
SCREENEND       equ 1535

BACKGROUND      equ 32

    org $3f00   32K CoCo

start
    lbsr savescreensub
    lbsr clearblacksub

    lbsr showmazesub

    * Player position.
    ldx #1024+32+1

    IFDEF KEEPGOING
    clr currentkey
    clr nextkey
    ENDC

mainloop
    *sync
    lda #42
    sta ,x
    tfr x,y * Save current position.

    lda #30
delay
    sync
    deca
    bne delay

keyreadloop
    IFDEF HOLDDOWN
    * To make key repeat work, clear the KEYBUF
    * by filling it with $ff.
    ldd #$ffff
    std KEYBUF
    std KEYBUF+2
    std KEYBUF+4
    std KEYBUF+6
    ENDC

    jsr [POLCAT]
    bne newkeypress

    IFDEF KEEPGOING
    lda currentkey
    bne checkkeys
    bra return
    ENDC

newkeypress

    IFDEF KEEPGOING
    tst currentkey
    bne nextkeypress

    sta currentkey
    * Debug
    sta 1024
    bra checkkeys

nextkeypress
    sta nextkey
    * Debug:
    sta 1025
    bra return
    ENDC

checkkeys
    ; cmpa #12
    ; beq clear

    cmpa #BREAKKEY
    beq quit

    cmpa #UPKEY
    beq up

    cmpa #DOWNKEY
    beq down

    cmpa #LEFTKEY
    beq left

    cmpa #RIGHTKEY
    beq right

    bra keyreadloop

clear
    lbsr clearblacksub
    bra mainloop

up
    cmpx #ENDOFFIRSTROW
    ble invalidmove
    leax -32,x
    bra checkpos

down
    cmpx #STARTOFLASTROW
    bge invalidmove
    leax 32,x
    bra checkpos

left
    cmpx #ENDOFFIRSTROW
    ble invalidmove
    leax -1,x
    bra checkpos

right
    cmpx #SCREENEND
    bge invalidmove
    leax 1,x

checkpos
    ldb ,x
    cmpb #BACKGROUND
    beq validmove
    * Restore previous position.
    tfr y,x
    bra invalidmove

validmove
    ldb #BACKGROUND * Erase old position
    stb ,y          * Save position.
    bra return

invalidmove
    tfr y,x         * Restore prev position

    IFDEF KEEPGOING
    lda nextkey
    beq nonextkey

    sta currentkey
    * Debug
    sta 1024

    clr nextkey
    * Debug
    clr 1025
    ENDC

    bra return

    IFDEF KEEPGOING
nonextkey
    clr currentkey
    * Debug
    clr 1024
    ENDC

return
    lbra mainloop

quit
    bsr restorescreensub
    rts

clearblacksub
    ldb #128
clearsub
    ldy #1024
clearloop
    stb ,y+
    cmpy #1535
    ble clearloop
    rts

savescreensub
    ldx #1024
    ldy #screenbuf
saveloop
    ldd ,x++
    std ,y++
    cmpx #1535
    blt saveloop
    rts

restorescreensub
    ldx #screenbuf
    ldy #1024
restoreloop
    ldd ,x++
    std ,y++
    cmpy #1535
    blt restoreloop
    rts

showmazesub
    pshs d,x,y
    ldx #mazedata
    ldy #1024
showmazeloop
    ldd ,x++
    std ,y++
    cmpy #1535
    blt showmazeloop
    puls d,x,y
    rts 

screenbuf rmb 512
#IFSYM KEEPGOING
currentkey rmb 1
nextkey rmb 1
#ENDC


mazedata
    fcc "XXXXXXXXXXXXXXXXXXXXXXXXXXXX    "
    fcc "X            XX            X    "
    fcc "X XXXX XXXXX XX XXXXX XXXX X    "
    fcc "X X  X X   X XX X   X X  X X    "
    fcc "X XXXX XXXXX XX XXXXX XXXX X    "
    fcc "X                          X    "
    fcc "X XXXX XX XXXXXXXX XX XXXX X    "
    fcc "X XXXX XX XXXXXXXX XX XXXX X    "
    fcc "X      XX    XX    XX      X    "
    fcc "XXXXXX XXXXX XX XXXXX XXXXXX    "
    fcc "     X XXXXX XX XXXXX X         "
    fcc "     X XX          XX X         "
    fcc "     X XX XXX--XXX XX X         "
    fcc "XXXXXX XX X      X XX XXXXXX    "
    fcc "          X      X              "
    fcc "XXXXXX XX X      X XX XXXXXX    "
    fcc "     X XX XXXXXXXX XX X         "
    fcc "     X XX          XX X         "
    fcc "     X XX XXXXXXXX XX X         "
    fcc "XXXXXX XX XXXXXXXX XX XXXXXX    "
    fcc "X            XX            X    "
    fcc "X XXXX XXXXX XX XXXXX XXXX X    "
    fcc "X XXXX XXXXX XX XXXXX XXXX X    "
    fcc "X   XX                XX   X    "
    fcc "XXX XX XX XXXXXXXX XX XX XXX    "
    fcc "XXX XX XX XXXXXXXX XX XX XXX    "
    fcc "X      XX    XX    XX      X    "
    fcc "X XXXXXXXXXX XX XXXXXXXXXX X    "
    fcc "X XXXXXXXXXX XX XXXXXXXXXX X    "
    fcc "X                          X    "
    fcc "XXXXXXXXXXXXXXXXXXXXXXXXXXXX    "

    END
