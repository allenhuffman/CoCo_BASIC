* lwasm attract32.asm -fbasic -oattract32.bas --map

    org $3f00

    opt c
    cmpx #1535
    ble loop

    CMPX #$0601
    BLE L4005

    opt c
start
    ldx #1024   X points to top left of 32-col screen
    opt cc,ct
loop
    lda ,x+     load A with what X points to and inc X
    bpl skip    if not >128, skip
    adda #16    add 16, changing to next color
    ora #$80    make sure high gfx bit is set
    sta -1,x    save at X-1
skip
    cmpx #1536  compare X with last byte of screen
    bne loop    if not there, repeat
    opt noct
    rts         done

    LDX #$03FF  * X=&H3FF (1023, byte before screen)
    LEAX $01,X  * X=X+1
    opt cc,ct
L4005
    LDA ,X      * A=PEEK(X)
    BGE L400D   * IF A<128 GOTO L400D
    ADDA #$10   * A=A+&H10:IF A>&HFF THEN A=A-&HFF
    ORA #$80    * A=A OR &H80
L400D
    STA ,X+     * POKE X,A:X=X+1
    CMPX #$0601 * Compare X to &H601 (two bytes past end)
    BLE L4005   * IF X<=&H601 GOTO L4005
    opt noct
    RTS         * RETURN


    END


