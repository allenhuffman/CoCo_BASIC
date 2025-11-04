10 PMODE 4,1:PCLS:SCREEN 1,1
20 COLOR 7 ' Set drawing color to bright white
30 LINE (128,96)-(0,0),PSET ' Draw top line to left point
40 LINE (0,0)-(255,191),PSET ' Draw bottom line to right point
50 LINE (255,191)-(128,96),PSET ' Draw right line to top point
60 LINE (128,96)-(255,0),PSET ' Draw left line to bottom point
70 LINE (255,0)-(0,191),PSET ' Draw diagonal line from bottom right to top left
80 LINE (0,191)-(255,191),PSET ' Draw diagonal line from top left to bottom right
90 GOTO 90

