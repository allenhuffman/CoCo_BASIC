* lwasm jsrtest.asm -fbasic -ojsrtest.bas --map

    org $3f00

init
    ldx #startmsg
    jsr print

    jsr breakcheck

    ldx #endmsg
    jsr print
    rts

breakcheck jsr newcode
    ldx #breakmsg
    jsr print
    rts

newcode ldx #newcodemsg
    bsr print
    *Sleas $02,s
    rts

print lda ,x+
    beq printdone
    jsr [$a002]
    bra print
printdone
    rts

startmsg fcc "START"
    fcb 13,0

breakmsg fcc "BREAK CHECK"
    fcb 13,0

newcodemsg fcc "NEW CODE"
    fcb 13,0

endmsg fcc "END"
    fcb 13,0
