* lwasm orgtest.asm -fbasic -oorgtest.bas --map

* Loading screen:

    org $400    start of 32-col screen
    * 512 bytes of screen data
    fill 128,512    black blocks

    org $3f00   last one sets EXEC address
    rts
