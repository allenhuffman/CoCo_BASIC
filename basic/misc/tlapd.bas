0 ' tlapd.BASIC
10 CLS:X=0:Y=0:XM=1:YM=1
20 DIM L$(4):FOR I=0 TO 4:READ L$(I)
21 FOR J=1 TO LEN(L$(I)):IF MID$(L$(I),J,1)=" " THEN C$=CHR$(191) ELSE C$=CHR$(207)
22 MID$(L$(I),J,1)=C$
25 NEXT:NEXT
30 L=X+Y*32
40 CLS4:FOR I=0 TO 4:PRINT@L+32*I,L$(I);:NEXT
50 X=X+XM:IF X<1 OR X>6 THEN XM=-XM:SOUND 50,1
60 Y=Y+YM:IF Y<1 OR Y>10 THEN YM=-YM:SOUND 100,1
70 GOTO 30
100 DATA "#   #  ###  ####  ####  #"
110 DATA " # #  #   # #   # #   # #"
120 DATA "  #   ##### ####  ####  #"
130 DATA "  #   #   # #   # #   #  "
140 DATA "  #   #   # #   # #   # #"
150 DATA END
