* lwasm spiralasm.asm -fbasic -ospiralasm.bas --map

    org $3f00

start:
 ldx #1024   * 10 CLS
 lda #96
 ldb #96
clearloop
 std ,x++
 cmpx #1536
 bne clearloop

                * 15 ' X=START MEM LOC
 ldx #1024      * 20 X=1024

                * 25 ' XS=XSTEPS (WIDTH)
 lda #32        * 30 XS=32
 sta XSTEPS
                * 35 ' YS=YSTEPS (HEIGHT)
 lda #16        * 40 YS=16
 sta YSTEPS
                * 45 ' B=CHAR TO POKE
 ldb #255       * 50 B=255
 bsr right      * 60 GOSUB 100

 ldx #1024      * 70 X=1024
 lda #18        * 71 XS=18
 sta XSTEPS
 lda #8         * 72 YS=8
 sta YSTEPS
 ldb #175       * 73 B=175 '143+32
 bsr right      * 74 GOSUB 100

 ldx #1294      * 75 X=1294 '1024+14+32*8
 lda #18        * 76 XS=18
 sta XSTEPS
 lda #8         * 77 YS=8
 sta YSTEPS
 ldb #207       * 78 B=207 '143+64
 bsr right      * 79 GOSUB 100

 ldx #1157      * 80 X=1157 '1024+5+32*4
 lda #22        * 81 XS=22
 sta XSTEPS
 lda #8         * 82 YS=8
 sta YSTEPS
 ldb #239       * 83 B=239 '143+96
 bsr right      * 84 GOSUB 100

goto            * 99 GOTO 99
    jsr [$a000] * POLCAT ROM routine
    cmpa #3     * break key
    bne goto
    rts

right           * 100 ' RIGHT
 lda XSTEPS     * 110 A=XS
rightloop
 stb ,x         * 120 POKE X,B
 deca           * 130 A=A-1
 beq rightdone  * 140 IF A=0 THEN 170
 leax 1,x       * 150 X=X+1
 bra rightloop  * 160 GOTO 120
rightdone
 leax 32,x      * 170 X=X+32
 dec YSTEPS     * 180 YS=YS-1
 beq done       * 190 IF YS=0 THEN 600

down            * 200 ' DOWN
 lda YSTEPS     * 210 A=YS
downloop
 stb ,x         * 220 POKE X,B
 deca           * 230 A=A-1
 beq downdone   * 240 IF A=0 THEN 270
 leax 32,x      * 250 X=X+32
 bra downloop   * 260 GOTO 220
downdone
 leax -1,x      * 270 X=X-1
 dec XSTEPS     * 280 XS=XS-1
 beq done       * 290 IF XS=0 THEN 600

left            * 300 ' LEFT
 lda XSTEPS     * 310 A=XS
leftloop
 stb ,x         * 320 POKE X,B
 deca           * 330 A=A-1
 beq leftdone   * 340 IF A=0 THEN 370
 leax -1,x      * 350 X=X-1
 bra leftloop   * 360 GOTO 320
leftdone
 leax -32,x     * 370 X=X-32
 dec YSTEPS     * 380 YS=YS-1
 beq done       * 390 IF YS=0 THEN 600

up              * 400 ' UP
 lda YSTEPS     * 410 A=YS
uploop
 stb ,x         * 420 POKE X,B
 deca           * 430 A=A-1
 beq updone     * 440 IF A=0 THEN 470
 leax -32,x     * 450 X=X-32
 bra uploop     * 460 GOTO 420
updone
 leax 1,x       * 470 X=X+1
 dec XSTEPS     * 480 XS=XS-1
 beq done       * 490 IF XS=0 THEN 600

 bra right      * 500 GOTO 100
done
 rts            * 600 RETURN

XSTEPS rmb 1
YSTEPS rmb 1
