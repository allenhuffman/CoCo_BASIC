ORGADDR EQU $3f00

GIVABF 	EQU     $B4F4  * 46324
INTCNV 	EQU     $B3ED  * 46061

       	org     ORGADDR
IN      RMB     2
OUT     RMB     2

start  	LDD     IN
        tfr     d,x    * transfer D to X so we can manipulate it
        leax    1,x    * add 1 to X
        tfr     x,d    * transfer X back to D
        std     OUT
return 	RTS

		end
		
* lwasm --decb -o defusr.bin defusr.asm
* lwasm --decb -f basic -o defusr.bas defusr.asm
* decb copy -2 -r defusr.bin ../Xroar/dsk/DRIVE0.DSK,DEFUSR.BIN