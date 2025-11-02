* 64K RAM TEST V2

    ORG $3F00

start:
    PSHS CC     Save CC
    ORCC #$50   Mask interrupts.
    
    STA $FFDF   Disable ROM
    CLR $FEFF
    DEC $FEFF
    LDA $FEFF
done:
    STA $FFDE   Enable ROM
    PULS CC     Restore CC
    STA $0400

    RTS         Return
