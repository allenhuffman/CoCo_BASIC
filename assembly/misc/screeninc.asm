    org $3f00

start ldx #1024
loop dec ,x+
 cmpx #1536
 bne loop
 bra start
 
 end
 