* lwasm uncrunch.asm -fbasic -ouncrunch.bas --map
*
* 0.00 2022-07-04 allenh - initial klunky version.
*

* Allow LIST to display graphics characters inside of quoted strings.

RVEC24  equ $1A6     UNCRUNCH BASIC LINE RAM hook

COMVEC  EQU $0120    Some BASIC locations we need.
LINBUF  EQU $02DC
SKP2    EQU $8C
LBUFMX  EQU 250

    org $3f00

init
    lda RVEC24      get op code
    sta savedrvec   save it
    ldx RVEC24+1    get address
    stx savedrvec+1 save it

    lda #$7e        op code for JMP
    sta RVEC24      store it in RAM hook
    ldx #newcode    address of new code
    stx RVEC24+1    store it in RAM hook
    rts             done

newcode
* UNCRUNCH A LINE INTO BASIC'S LINE INPUT BUFFER
LB7C2
    clr     AREWEQUOTED
    *JSR    >RVEC24     HOOK INTO RAM
    LEAS    2,S         Remove JSR from stack
    LEAX    4,X         MOVE POINTER PAST ADDRESS OF NEXT LINE AND LINE NUMBER
    LDY     #LINBUF+1   UNCRUNCH LINE INTO LINE INPUT BUFFER
LB7CB
    LDA     ,X+         GET A CHARACTER
    LBEQ    LB820       BRANCH IF END OF LINE

    * Check for quote/unquote
    cmpa    #34         Is A a quote character?
    bne     quotedone

togglequote
    tst     AREWEQUOTED
    bne     quoteoff
quoteon
    inc     AREWEQUOTED
    bra     quotedone
quoteoff
    clr     AREWEQUOTED Toggle quote mode off.

quotedone
    tst     AREWEQUOTED
    beq     notquoted

quoted
    * If we are quoted, just store whatever it is.
    lda     -1,x

    CMPY    #LINBUF+LBUFMX  TEST FOR END OF LINE INPUT BUFFER
    BCC     LB820   BRANCH IF AT END OF BUFFER
    *ANDA   #$7F    MASK OFF BIT 7
    STA     ,Y+     * SAVE CHARACTER IN BUFFER AND
    CLR     ,Y      * CLEAR NEXT CHARACTER SLOT IN BUFFER
    BRA     LB7CB   GET ANOTHER CHARACTER

notquoted
    lda     -1,x

    LBMI    LB7E6   BRANCH IF IT'S A TOKEN
    CMPA    #':     CHECK FOR END OF SUB LINE
    BNE     LB7E2   BRNCH IF NOT END OF SUB LINE
    LDB     ,X      GET CHARACTER FOLLOWING COLON
    CMPB    #$84    TOKEN FOR ELSE?
    BEQ     LB7CB   YES - DON'T PUT IT IN BUFFER
    CMPB    #$83    TOKEN FOR REMARK?
    BEQ     LB7CB   YES - DON'T PUT IT IN BUFFER
    FCB     SKP2    SKIP TWO BYTES
LB7E0
    LDA     #'!     EXCLAMATION POINT
LB7E2
    BSR     LB814   PUT CHARACTER IN BUFFER
    BRA     LB7CB   GET ANOTHER CHARACTER
* UNCRUNCH A TOKEN
LB7E6
    LDU     #COMVEC-10  FIRST DO COMMANDS
    CMPA    #$FF    CHECK FOR SECONDARY TOKEN
    BNE     LB7F1   BRANCH IF NON SECONDARY TOKEN
    LDA     ,X+     GET SECONDARY TOKEN
    LEAU    5,U     BUMP IT UP TO SECONDARY FUNCTIONS
LB7F1
    ANDA    #$7F    MASK OFF BIT 7 OF TOKEN
LB7F3
    LEAU    10,U    MOVE TO NEXT COMMAND TABLE
    TST     ,U      IS THIS TABLE ENABLED?
    BEQ     LB7E0   NO - ILLEGAL TOKEN
LB7F9
    SUBA    ,U      SUBTRACT THE NUMBER OF TOKENS FROM THE CURRENT TOKEN NUMBER
    BPL     LB7F3   BRANCH IF TOKEN NOT IN THIS TABLE
    ADDA    ,U      RESTORE TOKEN NUMBER RELATIVE TO THIS TABLE
    LDU     1,U     POINT U TO COMMAND DICTIONARY TABLE
LB801
    DECA            DECREMENT TOKEN NUMBER
    BMI     LB80A   BRANCH IF THIS IS THE CORRECT TOKEN
* SKIP THROUGH DICTIONARY TABLE TO START OF NEXT TOKEN
LB804
    TST     ,U+     GRAB A BYTE
    BPL     LB804   BRANCH IF BIT 7 NOT SET
    BRA     LB801   GO SEE IF THIS IS THE CORRECT TOKEN
LB80A
    LDA     ,U      GET A CHARACTER FROM DICTIONARY TABLE
    BSR     LB814   PUT CHARACTER IN BUFFER
    TST     ,U+     CHECK FOR START OF NEXT TOKEN
    BPL     LB80A   BRANCH IF NOT DONE WITH THIS TOKEN
    BRA     LB7CB   GO GET ANOTHER CHARACTER
LB814
    CMPY    #LINBUF+LBUFMX  TEST FOR END OF LINE INPUT BUFFER
    BCC     LB820   BRANCH IF AT END OF BUFFER
    ANDA    #$7F    MASK OFF BIT 7
    STA     ,Y+     * SAVE CHARACTER IN BUFFER AND
    CLR     ,Y      * CLEAR NEXT CHARACTER SLOT IN BUFFER
LB820
    RTS

* Unused at the moment.

savedrvec   rmb 3   call regular RAM hook
    rts             just in case...

AREWEQUOTED rmb 1

    end     $3f00
