* lwasm consout.asm -fbasic -oconsout.bas --map

* Convert any lowercase characters written to the
* screen (device #0) to uppercase.

DEVNUM equ $6f
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
    pshs b          save b
    ldb DEVNUM      get device number
    puls b          restore b
    bne continue    not device #0 (console)
uppercase
    cmpa #'a        compare A to lowercase 'a'
    blt continue    if less than, goto continue
    cmpa #'z        compare A to lowercase 'z'
    bgt continue    if greater than, goto continue
    suba #32        a = a - 32
continue
savedrvec rmb 3     call regular RAM hook
    rts             just in case...
