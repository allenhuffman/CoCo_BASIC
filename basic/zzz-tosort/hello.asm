ORGADDR EQU $3f00

CHROUT  EQU     $A002

       	org     ORGADDR

start  	ldx     #msg
loop    lda     ,x+
        beq     return
        jsr     [CHROUT]
        bra     loop
return 	rts

msg     fcc     /This is a secret message./
        fcb     0
        
		end
		
* lwasm --decb -o defusr.bin defusr.asm
* lwasm --decb -f basic -o hello.bas hello.asm
* decb copy -2 -r defusr.bin ../Xroar/dsk/DRIVE0.DSK,DEFUSR.BIN