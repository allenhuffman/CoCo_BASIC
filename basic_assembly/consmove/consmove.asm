* lwasm consmove.asm -fbasic -oconsmove.bas --map

* Allow embedded characters to move the cursor in a PRINT.

DEVNUM equ $6f      device number being used for I/O
CURPOS equ $88      location of cursor position in RAM
RVEC3 equ $167      console out RAM hook

    org $3f00

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

newcode
    * Do this only if DEVNUM is 0 (console)
    tst DEVNUM      is DEVNUM 0?          
    bne continue    not device #0 (console)

    * If here, device #0 (console)
    cmpa #'r        compare A to lowercase 'r'
    bne continue    if not, continue

    leas 2,s        remove PC from stack since we won't be returning there.

    * Now this is the start of what Color BASIC ROM does for PUTCHR:
LA30A
    pshs x,b,a
    ldx CURPOS      X points to current cursor position
    leax 1,x        increment X, skipping that location.
    jmp $a344       jump back into Color BASIC ROM code.

continue
savedrvec rmb 3     call regular RAM hook
    rts             just in case...

    end
    