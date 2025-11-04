10 POKE 65495,0
20 CLS
30 PRINT "  MEN: 1            SCORE: 1    ";
40 PRINT "X<0000000000000000000000000000>X";
50 PRINT "X ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ X";
60 PRINT "X                              X";
70 PRINT "X                              X";
80 PRINT "X          *                   X";
90 PRINT "X                              X";
100 PRINT "X                              X";
110 PRINT "X                              X";
120 PRINT "X                              X";
130 PRINT "X                              X";
140 PRINT "X               U              X";
150 PRINT "X(============================)X";
160 PRINT "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
170 PRINT "  X                          X  ";
180 PRINT " XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
190 FOR L=1024 TO 1535:V=PEEK(L)
200 IF V=88 THEN POKE L,207:GOTO 290
210 IF V=124 THEN POKE L,199:GOTO 290
220 IF V=126 THEN POKE L,203:GOTO 290
230 IF V=112 THEN POKE L,206:GOTO 290
240 IF V=94 THEN POKE L,204:GOTO 290
250 IF V=96 THEN POKE L,128:GOTO 290
260 IF V=104 THEN POKE L,193:GOTO 290
270 IF V=105 THEN POKE L,194:GOTO 290
280 IF V=125 THEN POKE L,200:GOTO 290
281 IF V=85 THEN POKE L,195:GOTO 290
282 IF V=106 THEN POKE L,207:GOTO 290
290 NEXT
300 GOTO 300

