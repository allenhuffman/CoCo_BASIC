* lwasm nocls.asm -fbasic -onocls.bas --map

* Make CLS not work...

RVEC22   equ    $1A0    CLS RAM hook

    org $7f00

init
    lda #$7e        op code for JMP
    sta RVEC22      store it in RAM hook
    ldx #newcode    address of new code
    stx RVEC22+1    store it in RAM hook

    rts             done

uninstall
    * TODO

newcode
    leas    2,s         remove PC from stack since we won't be returning there.
    rts

    end
    