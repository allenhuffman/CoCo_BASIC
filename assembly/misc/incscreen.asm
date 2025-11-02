
        org     $3f00

start   ldx     #message
loop    lda     ,x+
        beq     done
        jsr     [$a002]
        bra     loop
done    rts

message fcc     "HELLO, WORLD!"
        fcb     0

        end     $3f00
