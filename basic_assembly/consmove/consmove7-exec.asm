; lwasm consmove7-exec.asm -fbasic -oconsmove7-exec.bas --map --list
; decb copy -2 consmove7-exec.bin drive0.dsk,CONSMVEX.BIN

; Allow embedded characters to move the cursor in a PRINT
; This is the small version that only supports EXEC.

; Smaller, so it can load at $3f00 (16K) or $7f00 (32K).
ORGADDR     equ     $3f00       ; Where program loads in memory

;------------------------------------------------------------------------------
; Definitions
;------------------------------------------------------------------------------
UPCHAR      equ     'u          ; default character for up
DOWNCHAR    equ     'd          ; default character for down
LEFTCHAR    equ     'l          ; default character for left
RIGHTCHAR   equ     'r          ; default character for right

;------------------------------------------------------------------------------
; Absolute addresses of items in RAM variables
;------------------------------------------------------------------------------
; Direct Page
CURLIN      equ     $68         ; PV CURRENT LINE # OF BASIC PROGRAM, $FFFF = DIRECT
DEVNUM      equ     $6f         ; device number being used for I/O
CURPOS      equ     $88         ; location of cursor position in RAM
; Others
RVEC3       equ     $167        ; console out RAM hook
RVEC12      equ     $182        ; inputting a BASIC line
VIDRAM      equ     $400        ; VIDEO DISPLAY AREA

            org     ORGADDR

;------------------------------------------------------------------------------
; This code can be called by EXEC
;------------------------------------------------------------------------------
start       

;------------------------------------------------------------------------------
; EXEC would start here
;------------------------------------------------------------------------------
toggle      lda     savedrvec3,pcr      ; test if we have already installed
            bne     uninstall           ; if not 0, then gotouninstall
                                        ; else fall through to install
install     lda     savedrvec3,pcr      ; test if we have already installed
            bne     installed           ; if not 0, already installed

            ; Hijack the CONOUT routine
            lda     RVEC3               ; get RAM hook op code
            sta     savedrvec3,pcr      ; save it
            ldx     RVEC3+1             ; get RAM hook address
            stx     savedrvec3+1,pcr    ; save it

            lda     #$7e                ; op code for JMP
            sta     RVEC3               ; store it in RAM hook
            leax    newrvec3,pcr        ; address of new code
            stx     RVEC3+1             ; store it in RAM hook
    
            ; Hijack the LINE INPUT routine
            lda     RVEC12              ; get RAM hook op code
            sta     savedrvec12,pcr     ; save it
            ldx     RVEC12+1            ; get RAM hook address
            stx     savedrvec12+1,pcr   ; save it

            lda     #$7e                ; op code for JMP
            sta     RVEC12              ; store it in RAM hook
            leax    newrvec12,pcr       ; address of new code
            stx     RVEC12+1            ; store it in RAM hook

installed   rts

;------------------------------------------------------------------------------
; Uninstall hooks and restore original ones
;------------------------------------------------------------------------------
uninstall   lda     savedrvec3,pcr      ; get saved RAM hook op code
            beq     uninstalled         ; if zero, already uninstalled
            sta     RVEC3               ; restore RAM hook op code
            ldx     savedrvec3+1,pcr    ; get saved RAM hook address
            stx     RVEC3+1             ; restore RAM hook address

            lda     savedrvec12,pcr     ; get saved RAM hook op code
            sta     RVEC12              ; restore RAM hook op code
            ldx     savedrvec12+1,pcr   ; get saved RAM hook address
            stx     RVEC12+1            ; restore RAM hook address

            clr     savedrvec3,pcr      ; zero out to mark unused

uninstalled rts

;------------------------------------------------------------------------------
; Do this only if DEVNUM is 0 (console)
;------------------------------------------------------------------------------
newrvec3    tst     <DEVNUM         ; is DEVNUM 0?          
            bne     savedrvec3      ; not device #0 (console)

            ; Do this only if NOT in Direct mode
            pshs    a               ; save A
            lda     CURLIN          ; GET CURRENT LINE NUMBER (CURLIN)
            inca                    ; TEST FOR DIRECT MODE
            puls    a               ; restore A
            beq     savedrvec3      ; if 0, in direct mode

            leas    2,s             ; remove PC from stack since we won't
                                    ; return there

; Now this is the start of what Color BASIC ROM does for PUTCHR:
; PUT A CHARACTER ON THE SCREEN
;LA30A
            PSHS    X,B,A           ; SAVE REGISTERS
            LDX     CURPOS          ; POINT X TO CURRENT CHARACTER POSITION

;checkup    
            cmpa    up,pcr          ; is it the up character?
            bne     checkdown       ; if no, goto checkdown
            cmpx    #VIDRAM+32      ; compare X to start of second line
            blt     cantmove        ; if less than, goto cantmove
            leax    -32,x           ; move up one line
            bra     cursormoved     ; goto checksdone

checkdown   cmpa    down,pcr        ; is it the down character?
            bne     checkleft       ; if no, goto checkleft
            cmpx    #VIDRAM+512-32  ; compare X to start of bottom line
            bge     cantmove        ; if greater or equal, goto cantmove
            leax    32,X            ; move down one line
            bra     cursormoved     ; goto checksdone

checkleft   cmpa    left,pcr        ; is it the left character?
            bne     checkright      ; if no, goto checkright
            cmpx    #VIDRAM         ; top left of screen?
            beq     cantmove        ; if yes, goto cantmove
            leax    -1,X            ; move left one character
            bra     cursormoved     ; goto checksdone

checkright  cmpa    right,pcr       ; is it the right character?
            bne     goLA30E         ; if no, goto goLA30E
            cmpx    #VIDRAM+511     ; is it bottom right of screen?
            beq     cantmove        ; if yes, goto cantmove
            leax    1,x             ; increment X, skipping that location
            bra     cursormoved     ; goto checksdone

; This is the next instruction after PSHS X,B,A / LDX CURPOS in the ROM.
goLA30E     jmp     $A30E           ; jump back into Color BASIC ROM code

; This is the STX CURPOS / check for scroll routine in the ROM.
cursormoved jmp     $A344           ; jump back into Color BASIC ROM code.

; This is the PULS A,B,X,PC at the end of this routine in the ROM.
cantmove    jmp     $A35D           ; jump back into Color BASIC ROM code

savedrvec3  fcb     0               ; call regular RAM hook
            fcb     0
            fcb     0
            ;rts                     ; just in case..

;------------------------------------------------------------------------------
; William Astle: "RVEC12 would be right. You can clobber X in this case. You
; would check 2,s to see if it's $AC7F. If it is, you just set CURLIN to $FFFF
; This works around the unfortunate ordering of the instructions in the
; immediate mode loop."
;------------------------------------------------------------------------------
newrvec12   ldx     2,s             ; load X with address we were called from
            cmpx    #$ac7f          ; compare X to $AC7F
            bne     savedrvec12     ; if not that, goto savedrvec12 to return
            ldx     #$ffff          ; else, load X with $ffff (directo mode)
            stx     <CURLIN         ; update CURLINE

savedrvec12 fcb     0               ; call regular RAM hook
            fcb     0
            fcb     0
            ;rts                     ; just in case..

;------------------------------------------------------------------------------
; Placed at the end of the program memory for easy patching in the BASIC
; loader DATA statements
;------------------------------------------------------------------------------
up          fcb     UPCHAR
down        fcb     DOWNCHAR
left        fcb     LEFTCHAR
right       fcb     RIGHTCHAR

            end
    