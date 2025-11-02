* lwasm nobreak.asm -fbasic -onobreak.bas --map

* This won't work for all BREAK cases, since other
* places in the ROM jump directly to the check, bypassing
* the RAM Hook completely. Oh well.

RVEC11 equ $17f      break check RAM hook

    org $3f00

init
    ; lda RVEC11      get op code
    ; sta savedrvec   save it
    ; ldx RVEC11+1    get address
    ; stx savedrvec+1 save it

    lda #$7e        op code for JMP
    sta RVEC11      store it in RAM hook
    ldx #newcode    address of new code
    stx RVEC11+1    store it in RAM hook

    rts             done

newcode
    inc $400        inc top left byte of 32-col screen
    leas $02,s
    rts

; savedrvec rmb 3     call regular RAM hook
;     leas $02,S      remove PC from stack
;     rts             return back, skipping.
