* helloworld.asm

    org $3f00

    ldx #message
loop:
    lda ,x+
    beq done
    jsr [$a002]
    bra loop
done:
    rts

message fcc "HELLO WORLD!"
    fcb 13
    fcb 0
