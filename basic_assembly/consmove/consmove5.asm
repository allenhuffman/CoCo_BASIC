* lwasm consmove5.asm -fbasic -oconsmove5.bas --map

* Allow embedded characters to move the cursor in a PRINT.

ORGADDR equ     $3f00

UP      equ     'u      character for up
DOWN    equ     'd      character for down
LEFT    equ     'l      character for left
RIGHT   equ     'r      character for right

CURLIN  equ     $68     *PV CURRENT LINE # OF BASIC PROGRAM, $FFFF = DIRECT
DEVNUM  equ     $6f     device number being used for I/O
CURPOS  equ     $88     location of cursor position in RAM
RVEC3   equ     $167    console out RAM hook
RVEC12  equ     $182    inputting a BASIC line
VIDRAM  equ     $400    VIDEO DISPLAY AREA
INTCNV  EQU     $B3ED   * 46061
GIVABF  EQU     $B4F4   * 46324

    org ORGADDR

start
    jsr INTCNV          * get passed in value in D
    std 1024            * for debugging
    ldd #42
    jmp GIVABF

    cmpd #0             * if EXEC or USRx(0)...
    beq toggle          * ...toggle
    cmpd #1             * if 1...
    beq install         * ...install
    cmpd #-1            * if -1...
    beq uninstall       * ...uninstall

    ldx #msgunknown     * show Unknown message (debugging)
    bsr print
    bra return
    *rts

toggle
    lda savedrvec3      * test if we have already installed
    bne uninstall       * if not 0, then uninstall
                        * else fall through to install
install
    lda savedrvec3      * test if we have already installed
    bne installed       * if not 0, already installed

    * Hijack the CONOUT routine.
    lda RVEC3           * get op code
    sta savedrvec3      * save it
    ldx RVEC3+1         * get address
    stx savedrvec3+1    * save it

    lda #$7e            * op code for JMP
    sta RVEC3           * store it in RAM hook
    ldx #newcode        * address of new code
    stx RVEC3+1         * store it in RAM hook

    * Hijack the LINE INPUT routine.
    lda RVEC12          * get op code
    sta savedrvec12     * save it
    ldx RVEC12+1        * get address
    stx savedrvec12+1   * save it

    lda #$7e            * op code for JMP
    sta RVEC12          * store it in RAM hook
    ldx #newcode2       * address of new code
    stx RVEC12+1        * store it in RAM hook

installed
    bsr showinstalled   * show "installed" message.
    bra return

uninstall
    lda savedrvec3      * get saved op code
    beq uninstalled     * if zero, already uninstalled

    sta RVEC3           * restore op code
    ldx savedrvec3+1    * get saved address
    stx RVEC3+1         * restore address

    lda savedrvec12     * get saved op code
    sta RVEC12          * restor op code
    ldx savedrvec12+1   * get saved address
    stx RVEC12+1        * restore address

    clr savedrvec3      * zero out to mark unused.

uninstalled
    bsr showuninstalled * show "uninstalled" message

return
    ldd     #0
    jmp     GIVABF
    *rts

showinstalled
    ldx #msginstalled
    bsr print
    rts

showuninstalled
    ldx #msguninstalled
    bsr print
    rts

* PRINT subroutine. Prints the string pointed to by X.
print
    lda ,x+
    beq printdone
    jsr [$a002]
    bra print
printdone
    lda #13
    jsr [$a002]
    rts

* Data storage for the string messages.
msginstalled
    fcc "ON"
    fcb 0

msguninstalled
    fcc "OFF"
    fcb 0

msgunknown
    fcc "UNK"
    fcb 0

newcode
    * Do this only if DEVNUM is 0 (console)
    tst     DEVNUM      is DEVNUM 0?          
    bne     continue    not device #0 (console)

    * Do this only if NOT in Direct mode. Problem: After a BREAK, CURLIN
    * has not been updated yet, so the very first line you type will be
    * processing the special characters. Lines after that will not. Trying
    * to find a different way to detect this.
    pshs    a           save A
    lda     CURLIN      GET CURRENT LINE NUMBER (CURLIN)
    inca                TEST FOR DIRECT MODE
    puls    a           restore A
    beq     continue    if 0, in direct mode.

    leas    2,s         remove PC from stack since we won't be returning there.

* Now this is the start of what Color BASIC ROM does for PUTCHR:
* PUT A CHARACTER ON THE SCREEN
LA30A
    PSHS    X,B,A       SAVE REGISTERS
    LDX     CURPOS      POINT X TO CURRENT CHARACTER POSITION
    
checkup
    cmpa    #UP
    bne     checkdown
    CMPX    #VIDRAM+32  second line or lower?
    blt     goLA35D     disallow if on top line.
    leax    -32,x       move up one line
    bra     done

checkdown
    cmpa    #DOWN
    bne     checkleft
    cmpx    #VIDRAM+512-32
    bge     goLA35D     disallow if on bottom line.
    leax    32,X        move down one line
    bra     done

checkleft
    cmpa    #LEFT
    bne     checkright
    cmpx    #VIDRAM     top left of screen?
    beq     goLA35D
    leax    -1,X        move left one character
    bra     done

checkright
    cmpa    #RIGHT
    bne     goLA30E
    cmpx    #VIDRAM+511 bottom right of screen
    beq     goLA35D
    leax    1,x         increment X, skipping that location.
    bra     done

goLA30E
    jmp     $A30E       jump back into Color BASIC ROM code.

done
    stx     CURPOS      update cursor position
goLA35D
    jmp     $A35D       jump back into Color BASIC ROM code.

continue
savedrvec3  rmb 3        call regular RAM hook
    rts                 just in case...


* William Astle:
* "RVEC12 would be right. You can clobber X in this case. You would check 2,s
* to see if it's $AC7F. If it is, you just set CURLIN to $FFFF. This works
* around the unfortunate ordering of the instructions in the immediate mode
* loop."
newcode2
    ldx 2,s             get what called us
    cmpx #$ac7f
    bne continue2
    ldx #$ffff
    stx CURLIN

continue2
savedrvec12 rmb 3       call regular RAM hook
    rts                 just in case...

    end
    