1 DIM A$ (4)
10 FOR I = 1 TO 4
20 READ A$ (I)
30 NEXT I
40 FOR I = 1 TO 4
50 PRINT A$ (I) ;A$ (I) ;A$ (I)
60 NEXT I
70 FOR I = 3 TO 1 STEP -1
80 PRINT A$ (I);A$ (I) ;A$ (I)
90 NEXT I
300 DATA "   *  "
301 DATA "  * * "
302 DATA " *   *"
303 DATA "*     "
2046 END
