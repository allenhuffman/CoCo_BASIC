
 fcb $34,$01,$1A,$50,$10,$8E,$80,$00
 fcb $B7,$FF,$DE,$EC,$A4,$AE,$22,$EE
 fcb $24,$B7,$FF,$DF,$ED,$A1,$AF,$A1
 fcb $EF,$A1,$10,$8C,$FE,$FC,$25,$E8
 fcb $10,$8C,$FF,$00,$24,$0C,$B7,$FF
 fcb $DE,$EC,$A4,$B7,$FF,$DF,$ED,$A1
 fcb $20,$EE,$35,$01,$39

start:
    PSHS CC
    ORCC #$50
    LDY #$8000
loop1:    
    STA $FFDE
    LDD ,Y
    LDX $02,Y
    LDU $04,Y
    STA $FFDF
    STD ,Y++
    STX ,Y++
    STU ,Y++
loop2:    
    CMPY #$FEFC
    BCS loop1
    CMPY #$FF00
    BCC done
    STA $FFDE
    LDD ,Y
    STA $FFDF
    STD ,Y++
    BRA loop2
done:    
    PULS CC
    RTS
