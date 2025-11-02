;* lwasm consmove6.asm -fbasic -oconsmove6.bas --map
;* decb copy -2 consmove6.bin drive0.dsk,CONSMOVE.BIN

;USR     SET     0       ;* Support DEF USR. Comment out for just EXEC.

;* Allow embedded characters to move the cursor in a PRINT.

ORGADDR equ     $3e00   ;* Where program loads in memory.

UP      equ     'u      default character for up
DOWN    equ     'd      default character for down
LEFT    equ     'l      default character for left
RIGHT   equ     'r      default character for right

;* Absolute addresses of items in RAM variables.
CURLIN      equ     $68     ;*PV CURRENT LINE # OF BASIC PROGRAM, $FFFF = DIRECT
DEVNUM      equ     $6f     device number being used for I/O
CURPOS      equ     $88     location of cursor position in RAM
EXECJP      equ     $9d     location of jump address for EXEC
RVEC3       equ     $167    console out RAM hook
RVEC12      equ     $182    inputting a BASIC line
VIDRAM      equ     $400    VIDEO DISPLAY AREA

;* Absolute addresses of ROM calls.
CHROUT  equ	    $A002
INTCNV  equ     $B3ED
GIVABF  equ     $B4F4

    org     ORGADDR

;* This code expects to have been called by USRx(x).
start       cmpx	    #start      ;* called by "EXEC xxxx"?
            beq         fromexec
            cmpx        #$abab      ;* called by "EXEC"
            bne         fromusr
            ldx         EXECJP
            cmpx	    #start      ;* called by "EXEC xxxx"?
            beq         fromexec
fromusr
            leax        usrmsg,pcr
            lbsr        print
            rts
fromexec    leax        execmsg,pcr
            lbsr        print
            rts

usrmsg      fcc         "FROM USR"
            fcb         0

execmsg     fcc         "FROM EXEC"
            fcb         0


    beq     donumber            ;* if A=0, number passed in. goto donumber.
    inca                        ;* inc A so if 255 (string) it will be 0 now.
    beq     dostring            ;* if A=0 (was 255), string. goto dostring.
    bra     unknown             ;* else, goto unknown (this should never happen).

;* Restore default up, down, left and right characters.
defaults
    lda     #UP
    sta     up,pcr
    lda     #DOWN
    sta     down,pcr
    lda     #LEFT
    sta     left,pcr
    lda     #RIGHT
    sta     right,pcr
    lbra    exitsuccess         ;* TODO: reorganize to use just "bra".

dostring                        ;* X will be VARPTER, B will be string length.
    tstb                        ;* B=0?
    beq     defaults            ;* if yes, goto defaults.
    cmpb    #4                  ;* is B=4? (4 characters - up, down, left, right.)
    bne     exiterror           ;* if no, goto exiterror.
    ldy     2,x                 ;* load Y with address of string data.
    ldd     ,y++                ;* load D with UP and DOWN characters, inc Y twice.
    std     up,pcr              ;* store them at up and down.
    ldd     ,y                  ;* load D with LEFT and RIGHT characters.
    std     left,pcr            ;* store them at left and right.
    bra     exitsuccess         ;* goto exitsuccess.

donumber
    jsr     INTCNV              ;* get passed in value in D
    cmpd    #0                  ;* is D=0? USRx(0)
    beq     toggle              ;* if yes, goto toggle
    cmpd    #1                  ;* is D=1? USRx(1)
    beq     install             ;* if yes, goto install
    cmpd    #-1                 ;* is D=-1? USRx(-1)
    beq     uninstall           ;* if yes, goto uninstall

unknown
    leax    msgunknown,pcr      ;* load X with address of "unknown" message.
    bsr     print               ;* call the print subroutine
    bra     exiterror           ;* goto exiterror

;*------------------------------------------------------------------------------
;* EXEC would start here.
;*------------------------------------------------------------------------------
toggle
    lda     savedrvec3,pcr      ;* test if we have already installed
    bne     uninstall           ;* if not 0, then uninstall
                                ;* else fall through to install
install
    lda     savedrvec3,pcr      ;* test if we have already installed
    bne     installed           ;* if not 0, already installed

    ;* Hijack the CONOUT routine.
    lda     RVEC3               ;* get RAM hook op code
    sta     savedrvec3,pcr      ;* save it
    ldx     RVEC3+1             ;* get RAM hook address
    stx     savedrvec3+1,pcr    ;* save it

    lda     #$7e                ;* op code for JMP
    sta     RVEC3               ;* store it in RAM hook
    leax    newrvec3,pcr        ;* address of new code
    stx     RVEC3+1             ;* store it in RAM hook

    ;* Hijack the LINE INPUT routine.
    lda     RVEC12              ;* get RAM hook op code
    sta     savedrvec12,pcr     ;* save it
    ldx     RVEC12+1            ;* get RAM hook address
    stx     savedrvec12+1,pcr   ;* save it

    lda     #$7e                ;* op code for JMP
    sta     RVEC12              ;* store it in RAM hook
    leax    newrvec12,pcr       ;* address of new code
    stx     RVEC12+1            ;* store it in RAM hook

installed
    leax    msginstalled,pcr    ;* load X with address of "installed" message.
    bsr     print               ;* call the print subroutine
    bra     exitsuccess         ;* goto exitsuccess

exiterror
    rts
    ldd     #-1                 ;* return -1 as an error code
    bra     return              ;* goto return
exitsuccess
    ldd     #0                  ;* return 0 as an error code
return
    jmp     GIVABF              ;* return value back to USRx()

;* PRINT subroutine. Prints the 0-terminated string pointed to by X plus CR.
print
    lda     ,x+
    beq     printdone
    jsr     [CHROUT]
    bra     print
printdone
    lda     #13
    jsr     [CHROUT]
    rts

uninstall
    lda     savedrvec3,pcr      ;* get saved RAM hook op code
    beq     uninstalled         ;* if zero, already uninstalled

    sta     RVEC3               ;* restore RAM hook op code
    ldx     savedrvec3+1,pcr    ;* get saved RAM hook address
    stx     RVEC3+1             ;* restore RAM hook address

    lda     savedrvec12,pcr     ;* get saved RAM hook op code
    sta     RVEC12              ;* restore RAM hook op code
    ldx     savedrvec12+1,pcr   ;* get saved RAM hook address
    stx     RVEC12+1            ;* restore RAM hook address

    clr     savedrvec3,pcr      ;* zero out to mark unused.

uninstalled
    leax    msguninstalled,pcr
    bsr     print
    bra     exitsuccess

;* Data storage for the string messages.
msginstalled
    fcc     "ON"
    fcb     0

msguninstalled
    fcc     "OFF"
    fcb     0

msgunknown
    fcc     "UNK"
    fcb     0

newrvec3
    ;* Do this only if DEVNUM is 0 (console)
    tst     DEVNUM          ;* is DEVNUM 0?          
    bne     savedrvec3      ;* not device #0 (console)

    ;* Do this only if NOT in Direct mode.
    pshs    a               ;* save A
    lda     CURLIN          ;* GET CURRENT LINE NUMBER (CURLIN)
    inca                    ;* TEST FOR DIRECT MODE
    puls    a               ;* restore A
    beq     savedrvec3      ;* if 0, in direct mode.

    leas    2,s             ;* remove PC from stack since we won't return there.

;* Now this is the start of what Color BASIC ROM does for PUTCHR:
;* PUT A CHARACTER ON THE SCREEN
;LA30A
    PSHS    X,B,A           ;SAVE REGISTERS
    LDX     CURPOS          ;POINT X TO CURRENT CHARACTER POSITION
    
;checkup
    cmpa    up,pcr          ;* is it the up character?
    bne     checkdown       ;* if no, goto checkdown.
    cmpx    #VIDRAM+32      ;* compare X to start of second line.
    blt     goLA35D         ;* if less than, goto goLA35D.
    leax    -32,x           ;* move up one line.
    bra     checksdone      ;* goto checksdone.

checkdown
    cmpa    down,pcr        ;* is it the down character?
    bne     checkleft       ;* if no, goto checkleft.
    cmpx    #VIDRAM+512-32  ;* compare X to start of bottom line.
    bge     goLA35D         ;* if greater or equal, goto goLA35D.
    leax    32,X            ;* move down one line
    bra     checksdone      ;* goto checksdone.

checkleft
    cmpa    left,pcr        ;* is it the left character?
    bne     checkright      ;* if no, goto checkright.
    cmpx    #VIDRAM         ;* top left of screen?
    beq     goLA35D
    leax    -1,X            ;* move left one character
    bra     checksdone      ;* goto checksdone.

checkright
    cmpa    right,pcr       ;* is it the right character?
    bne     goLA30E         ;* if no, goto goLA30E.
    cmpx    #VIDRAM+511     ;* is it bottom right of screen?
    beq     goLA35D         ;* if yes, goto goLA35D.
    leax    1,x             ;* increment X, skipping that location.
    bra     checksdone      ;* goto checksdone.

goLA30E
    jmp     $A30E           ;* jump back into Color BASIC ROM code.

checksdone
    stx     CURPOS          ;* update cursor position
goLA35D
    jmp     $A35D           ;* jump back into Color BASIC ROM code.

savedrvec3 
    fcb     0               ;* call regular RAM hook
    fcb     0
    fcb     0
    rts                     ;* just in case...

;* William Astle:
;* "RVEC12 would be right. You can clobber X in this case. You would check 2,s
;* to see if it's $AC7F. If it is, you just set CURLIN to $FFFF. This works
;* around the unfortunate ordering of the instructions in the immediate mode
;* loop."
newrvec12
    ldx     2,s             ;* load X with address we were called from.
    cmpx    #$ac7f          ;* compare X to $AC7F.
    bne     savedrvec12     ;* if not that, goto savedrvec12 to return.
    ldx     #$ffff          ;* else, load X with $ffff (directo mode)
    stx     CURLIN          ;* update CURLINE.

savedrvec12
    fcb     0               ;* call regular RAM hook
    fcb     0
    fcb     0
    rts                     ;* just in case...

;* Placed at the end of the program memory for easy patching in the BASIC
;* loader DATA statements.
up      fcb     UP
down    fcb     DOWN
left    fcb     LEFT
right   fcb     RIGHT

    ENDC

    end
    