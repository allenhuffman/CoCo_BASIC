0 'PALETTE12,63:PALETTE13,0
9 CLS
10 PRINT"             #####
11 PRINT"    ##########   ##########
12 PRINT"   #           #           #
13 PRINT" ### ###### ####### ###### ###
14 PRINT" #   #                   #   #
15 PRINT" # ### ################# ### #
16 PRINT" #       #           #       #
17 PRINT" #######   #### ####   #######
18 PRINT"     #                   #
19 PRINT"     # ###### # # ###### #
20 PRINT"     # #      ###      # #
21 PRINT"     #   ####     ####   #
22 PRINT"     ###    #######    ###
23 PRINT"       ####         ####
24 PRINT"          ###########
25 MX=15:MY=1:PX=15:PY=13
30 POKE1024+(PY*32+PX),80:POKE1024+(MY*32+MX),96
31 PRINT@512-32,PX;PY;XP;YP,MX;MY;X;Y;
35 X=SGN(PX-MX):Y=SGN(PY-MY):Z=(1024+(MY*32+MX))
36 IFPEEK(Z+(Y*32))=96 THENMY=MY+Y ELSEIFPEEK(Z+Y*32+X)=96 THENMX=MX+X:GOTO39
37 IFPEEK(Z+X)=96 THENMX=MX+X:GOTO39
39 POKE1024+(MY*32+MX),42
40 A$=INKEY$:IFA$=""THEN55
45 IFA$="W"THENYP=-1:XP=0 ELSEIFA$="Z"THENYP=+1:XP=0
50 IFA$="A"THENXP=-1:YP=0 ELSEIFA$="S"THENXP=+1:YP=0
55 IFPEEK(1024+(PY*32+PX)+(32*YP)+XP)=96 THENPOKE(1024+PY*32+PX),96:PX=PX+XP:PY=PY+YP
60 GOTO30
999 GOTO999
