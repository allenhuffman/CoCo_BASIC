10 PMODE 4,1:PCLS:SCREEN 1,1
20 ' Top center to bottom left
30 LINE(128,0)-(0,191),PSET
40 ' continue to middle right
50 LINE-(255,95),PSET
60 ' continue to middle left
70 LINE-(0,95),PSET
80 ' continue to bottom right
90 LINE-(255,191),PSET
100 ' continue to top center
110 LINE-(128,0),PSET
120 GOTO 120
