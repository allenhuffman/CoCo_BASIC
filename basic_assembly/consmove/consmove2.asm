* lwasm consmove2.asm -fbasic -oconsmove2.bas --map

* Allow embedded characters to move the cursor in a PRINT.

UP      equ     'u      character for up
DOWN    equ     'd      character for down
LEFT    equ     'l      character for left
RIGHT   equ     'r      character for right

DEVNUM  equ     $6f     device number being used for I/O
CURPOS  equ     $88     location of cursor position in RAM
RVEC3   equ     $167    console out RAM hook
VIDRAM  equ     $400    VIDEO DISPLAY AREA

    org $7f00

init
    lda RVEC3       get op code
    sta savedrvec   save it
    ldx RVEC3+1     get address
    stx savedrvec+1 save it

    lda #$7e        op code for JMP
    sta RVEC3       store it in RAM hook
    ldx #newcode    address of new code
    stx RVEC3+1     store it in RAM hook

    rts             done

uninstall
    * TODO

newcode
    * Do this only if DEVNUM is 0 (console)
    tst     DEVNUM      is DEVNUM 0?          
    bne     continue    not device #0 (console)

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
savedrvec rmb 3         call regular RAM hook
    rts                 just in case...

    end
    