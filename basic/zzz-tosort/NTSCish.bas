0 REM NTSCish.bas
1 ' 1 = green
2 ' 2 = yellow
3 ' 3 = blue
4 ' 4 = red
5 ' 5 = buff (white)
6 ' 6 = cyan (light blue)
7 ' 7 = magenta
8 ' 8 = orange
10 CLS0:X=4
20 READ C:IF C=-1 THEN 999
30 FOR X=X TO X+7
40 FOR Y=0 TO 31
50 SET (X,Y,C)
60 NEXT:NEXT
70 GOTO 20
999 GOTO 999
1000 DATA 5,2,6,1,7,4,3,-1
