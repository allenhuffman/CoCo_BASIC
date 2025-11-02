* 64K RAM TEST V1

    ORG $3F00

start:
    PSHS CC     Save CC
    ORCC #$50   Mask interrupts.
    
    STA $FFDF   Disable ROM
    LDA #'Y     Load A with 'Y'
    STA $FEFF   Store A in last RAM byte
    CLRA        Clear A
    LDA $FEFF   Load A with last RAM byte
    CMPA #'Y    Compare to 'Y'
    BEQ done    If Y, done.
    LDA #'N     Else, load A with 'N'
done:
    STA $FFDE   Enable ROM
    PULS CC     Restore CC
    JSR [$A002] Output byte in A to console.

    RTS         Return
