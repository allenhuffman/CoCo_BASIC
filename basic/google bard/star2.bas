10 PMODE 4,1:PCLS:SCREEN 1,1
20 COLOR 7 ' Set drawing color to bright white
30 PI = 3.14159 ' Define pi constant
40 ANGLE = 360 / 5 ' Calculate angle between star points
50 RADIUS = 100 ' Set star radius

60 FOR I = 0 TO 4 ' Loop for each star point
70 X = 128 + RADIUS * COS(ANGLE * I) ' Calculate X coordinate using trigonometry
80 Y = 96 + RADIUS * SIN(ANGLE * I) ' Calculate Y coordinate using trigonometry
90 LINE (128,96)-(X,Y),PSET ' Draw line from center to each point
100 NEXT I
110 GOTO 110
