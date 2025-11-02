* 64K ROM to RAM

    ORG $3F00

start:
    PSHS CC     Save CC
    ORCC #$50   Mask interrupts.
    
    LDX #$8000  Start of ROM
loop:    
    STA $FFDE   Enable ROM
    LDD ,X      Load D with whatever is at X
    STA $FFDF   Disable ROM
    STD ,X++    Store D at X and increment X
    CMPX #$FF00 Is X past end of ROM?
    BNE loop    If not, repeat.

    PULS CC,PC  Restore CC and return
