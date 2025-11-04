* SCRNWRAP.ASM v1.00
* by Allen C. Huffman of Sub-Etha Software
* www.subethasoftware.com / alsplace@pobox.com
*
* DEFUSRx() screen moving function
*
* INPUT:   direction (1=up, 2=down, 3=left, 4=right)
* RETURNS: 0 on success
*         -1 if invalid direction
*
* 1.00  changed to wraparound all directions
*
* EXAMPLE:
*   CLEAR 200,&H3F00
*   DEFUSR0=&H3F00
*   A=USR0(1)
*
ORGADDR EQU     $3f00

INTCNV  EQU     $B3ED   * 46061
GIVABF  EQU     $B4F4   * 46324

SCREEN  EQU     1024+32 * top left of screen
END     EQU     1535-32 * bottom right of screen

        opt	    6809    * 6809 instructions only
        opt	    cd      * cycle counting

        org     ORGADDR

start   jsr     INTCNV  * get incoming param in D
        tsta            * see if A is zero
        bne     error   * anything in A means >255
        decb            * decrement B
        beq     up      * if one DEC got us to zero
        decb            * decrement B
        beq     down    * if two DECs...
        decb            * decrement B
        beq     left    * if three DECs...
        decb            * decrement B
        lbeq     right   * if four DECs...
        
error   ldd     #-1     * load D with -1 for error code
        bra    exit

*
* Wrap screen UP
*
up      pshs    y
        ldx     #SCREEN * save top line
        bsr     saveln

uploop  ldd     ,x++    * load D with 2-bytes at X, inc++
        std     -34,x   * store
        cmpx    #END
        ble     uploop
        
        ldx     #END-31 * restore top line to bottom line
        bsr     restln

        puls    y
        bra     return

*
* Wrap screen DOWN
*
down    pshs    y       * save Y for later
        ldx     #END-31 * save bottom line
        bsr     saveln

        ldx     #END-31
downlp  ldd     ,--x
        std     32,x
        cmpx    #SCREEN
        bgt     downlp

        ldx     #SCREEN * restore bottom line to top line
        bsr     restln

        puls    y       * restore Y
        bra     return

*
* Save line in buffer
* X=points to line to save
*
saveln  ldy     #buffer
savelp  ldd     ,x++
        std     ,y++
        cmpy    #bufend
        blt     savelp
        rts

*
* Restore line from buffer
* X=points to where to restore line
*
restln  ldy     #buffer
restlp  ldd     ,y++
        std     ,x++
        cmpy    #bufend
        blt     restlp
        rts
        
return  ldd     #0      * return code (0=success)
exit    jmp     GIVABF  * return to BASIC

*
* Wrap screen LEFT
*
left    ldx     #SCREEN
        lda     ,x          * get top left character
        pshs    a           * push A on user stack

        ldx     #SCREEN+1
leftlp  ldd     ,x++
        std     -3,x
        cmpx    #END-1
        ble     leftlp
        
        lda     ,x
        sta     -1,x
        
        puls    a           * pull A from user stack
        sta     ,x
        
        bra     return

*
* Wrap screen RIGHT
*
right   ldx     #END        * bottom right of screen
        lda     ,x          * get bottom right character
        pshs    a           * save for later

        ldx     #END-2
rightlp ldd     ,x          * get 2 characters in D
        std     1,x         * store them one character right
        leax    -2,x
        cmpx    #SCREEN     * top left of screen?
        bgt     rightlp
        
        ldx     #SCREEN
        ldb     ,x
        puls    a
        std     ,x
        
        bra     return

buffer  rmb     32
bufend          *-buffer-1
        
* lwasm --decb -9 -o SCRNWRAP.bin scrnwrap.asm
* lwasm --decb -f basic -o SCRNWRAP.BAS scrnwrap.asm
* decb copy -2 -r SCRNWRAP.BAS ../Xroar/dsk/DRIVE0.DSK,SCRNWRAP.BIN
