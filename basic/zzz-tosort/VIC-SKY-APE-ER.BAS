1 POKE 808,100
5 REM  ************          *SKY-APE-ER*        *******BY*******
6 REM*ALLEN  HUFFMAN*      ****************{$cc}
10 S=1:POKE36879,26:POKE36878,15:S1=36875:POKE775,200:POKE36869,255
15 PRINT"{clear}":L=8118:B=7772:M=15
20 FORA=38400TO38905:POKEA,0:NEXTA
25 PRINT"{home}{down}{right}{black}ABC{down}{left:3}DEF{down}{left:3}GHI{down}{left:3}JKL"
30 ONSGOTO35,45,55,500
35 PRINT"{red}@@@@@@@@@@@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@@@@@@@@@@@@@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@@@@@@@@@@@@@@@{down}{left}";
40 PRINT"@@@{down}{left}@@@{down}{left}@@@@@@@@@@@@@@@@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@@@@@@@@@{up}{left}@{up}{left}@{up}{left}@":GOTO70
45 PRINT"{blue}@@@@@@@@@@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@@@@@@@@@@@@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{down}{left}";
50 PRINT"@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@@@@@@@@@@@@@@@@{up}{left}@{up}{left}@{up}{left}@":GOTO70
55 PRINT"{purple}@@@@@@@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{up:3}@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{down}{left}";
60 PRINT"@@@{up:4}{left}@@@{down}{left}@@@@@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@{down}{left}@@@@@@@@@{up}{left}@{up}{left}@{up}{left}@{up}{left}@{up}{left}@"
70 T=0
80 POKEL,M:POKEB,32:POKES1,0
83 IFL=7772ORL=7749THEN400
84 IFL=BTHEN250
85 B=B+23:IFPEEK(B)=0THENB=B-22:POKEB,16
87 IFPEEK(L+22)=32THENPOKEL,32:L=L+22:POKEL,M
90 POKES1,240:POKES1,0
95 IFB=LTHEN250
100 IFB=8118THENPOKEB,32:B=7772:POKEB,12
105 PRINT"{home}{blue}{rvrs on}{right}TIME:";T:T=T+1
110 IFT>200THEN300
115 K=PEEK(197):IFK=64THEN80
120 POKEL,32:POKES1,230
125 IFK=17THENL=L-1:M=14
130 IFK=41THENL=L+1:M=13
135 IFK=39THEN180
140 IFPEEK(L)=0THEN150
145 GOTO80
150 IFK=17THENL=L+1
155 IFK=41THENL=L-1
160 M=15:GOTO80
180 POKES1,235:IFM=14THENL=L-23
183 IFM=15THENL=L-22
185 IFM=13THENL=L-21
190 IFPEEK(L)=0THEN200
195 M=15:GOTO80
200 IFM=13THENL=L+21
210 M=15:GOTO80
250 FORA=1TO11:READN,L:POKES1,N:FORP=1TOL:NEXTP:POKES1,0:NEXTA
255 PRINT"{clear}{black}{rvrs on}{down} GUESS WHAT! YOU HAVE {down}JUST BEEN STRUCK DOWN {down}  BY A LUCKY CHIMP!"
260 PRINT"{rvrs on}{down}({blue}THAT MEANS {red}GAME OVER{black})"
265 GOTO450
270 DATA202,250,202,250,202,150,202,350,210,250,208,150,208,200,202,200,202,250,200,200
275 DATA 202,400
285 PRINT"{down:2}{rvrs on}PRESS ANY KEY TO START"
300 PRINT"{clear}{black}{rvrs on}{down:3}WELL WHAT DO YOU KNOW?"
305 PRINT"{rvrs on}{down:2}WHILE YOU WERE DOWN ONTHE GROUND JUMPING A- ROUND,YOUR TIME CLOCK"
310 PRINT"{rvrs on}    JUST RAN OUT!"
315 PRINT"{rvrs on}{down:2}  NEXT TIME {red}WATCH{black} THE CLOCK!"
320 GOTO450
400 S=S+1:GOTO15
450 PRINT"{black}{rvrs on}{down:2}{right}WILL YOU TRY AGAIN?"
455 GETA$:IFA$=""THEN455
460 IFA$="N"THEN550
465 IFA$="Y"THEN480
470 GOTO455
480 PRINT"{clear}{black}{rvrs on}{down:2}AT LAST! SOMEONE BRAVE ENOUGH TO {red}TRY{black} TO STOP  KING KING'S COUSIN!"
490 GETA$:IFA$=""THEN490
495 RUN
500 PRINT"{clear}{black}"
505 FORZ=0TO16:PRINT"{home}":FORR=0TOZ:PRINT:NEXTR
510 PRINT"   {down}{left:3}ABC{down}{left:3}DEF{down}{left:3}GHI{down}{left:3}JKL"
515 NEXTZ
525 POKE36874,128
530 FORX=15TO0STEP-.1:POKE36878,X:NEXTX:POKE36874,0
535 PRINT"{clear}{black}{rvrs on}{down:3}CONGRATULATIONS!!!!!!!{down} YOU NOW KNOW WHAT IT  FEELS LIKE TO BE ON"
540 PRINT"{rvrs on}TOP!{$a0}YOU PLAYED WELL!"
545 PRINT"{rvrs on}{down:2}{blue}BET YOU DON'T WIN NEXT       TIME!"
548 PRINT:GOTO450
550 PRINT"{clear}{black}{rvrs on}I DIDN'T THINK YOU HAD ENOUGH COURAGE TO TRY   TO STOP A MAD APE!"
560 PRINT"{down}{rvrs on}{red}I HOPE YOU ENJOYED NOT SAVING THE BUILDING!"
565 FORG=1TO10000:NEXTG
570 SYS64802
