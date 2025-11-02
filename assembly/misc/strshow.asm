* lwasm strshow.asm -fbasic -ostrshow.bas --map

FRETOP  equ $21     Start of string storage.
STRTAB  equ $23     Start of string variables.
MEMSIZ  equ $27     Top of string space.

VIDRAM  equ $0400   Video display area.

    org $3f00

start
    ldx FRETOP
    leax 1,x
clear
    cmpx STRTAB
    beq cont
    lda #96
    sta ,x+
    bra clear
cont
    ldx FRETOP
    leax 1,x
    ldy #VIDRAM
loop
    lda ,x+
    sta ,y+
    cmpx MEMSIZ
    bge done
    cmpy #VIDRAM+256
    ble loop
done
    rts

    end $3f00
