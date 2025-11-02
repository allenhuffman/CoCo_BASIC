* war.asm

        LDX #$03FF
        LEAX $01,X
L4005   LDA ,X
        BGE L400D
        ADDA #$10
        ORA #$80
L400D   STA ,X+
        CMPX #$0601
        BLE L4005
        RTS
