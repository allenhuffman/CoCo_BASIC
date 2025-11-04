!--------------------------------------------------
!- April 8, 2020 10:15:46 PM
!- Import of : 
!- w:\vicconversions\victnt\tnt.prg
!- Unexpanded VIC20 / C16 / Plus4
!--------------------------------------------------
0 POKE45,56:POKE46,26:POKE51,0:POKE52,28:POKE55,0:POKE56,28:CLR
5 REM***************       * FACTORY TNT *       ******BY:******
6 REM*ALLEN HUFFMAN*       ***************
10 POKE36869,255:POKE36879,25:POKE650,255:PRINT"{clear}{black}":ML=3:SC=0:POKE36878,15
15 PRINT"@abbbbbbbbbbbbbbbbbbc@@{right}dddddddddddddddddd{right}@";
20 FORA=1TO16:PRINT"@{space*20}@";:NEXTA
25 PRINT"@ghhhhhhhhhhhhhhhhhhi@@@@@@@@@@@@@@@@@@@@@@@{space*2}@{space*16}@"
30 PRINT"{right}@@@@@@@@@@@@@@@@@@@@";
35 L=8086
40 B=INT(RND(1)*18)+7748
42 PRINT"{home}{space*2}{reverse on}men:{reverse off}";ML;" {reverse on}score:{reverse off}";SC
45 POKEL,6:POKEB,5:POKE36875,0:WAIT653,1,1
50 A=A+1:IFA=>3THENPOKEB,32:B=B+22:POKEB,5:A=1
55 IFB=>8076THEN150
100 GETA$:IFA$=""THEN45
105 POKEL,32
110 IFA$="a"THENL=L-1
115 IFA$="s"THENL=L+1
120 IFPEEK(L)=0THEN130
125 GOTO45
130 IFA$="a"THENL=L+1
135 IFA$="s"THENL=L-1
140 GOTO45
150 IFB=LTHEN200
155 POKEB,10
160 POKE36877,128
165 FORQ=15TO0STEP-.1:POKE36878,Q:NEXTQ
170 POKE36877,0:POKEB,32
175 ML=ML-1
180 IFML=0THEN250
190 GOTO40
200 SC=SC+10:POKE36875,150:POKE36878,15:POKE36875,200
205 GOTO40
250 POKE36869,240:PRINT"{clear}"
255 PRINT"{black}*****************************{red}g{blue}a{cyan}m{purple}e {yellow}o{blue}v{red}e{purple}r{black}****************************"
260 IF SC>TP THEN TP=SC:GOTO300
265 PRINT"{down*2}final score:";SC
270 PRINT"{down}top score{space*2}:";TP
275 PRINT"{down*2}====player rating===="
285 IFSC=<50THENR$="dishwasher"
286 IFSC<100ANDSC>50THENR$="private"
287 IFSC=>100ANDSC<200THENR$="getting better"
288 IF SC=>200ANDSC>300THENR$="well done!"
289 IFSC=>300THENA$="super fantastic, extragreat, top dog, #1"
290 PRINT"{down}rank:{down}":PRINTR$
295 PRINT"{down}will you play again?"
296 GETQ$:IFQ$=""THEN296
297 IFQ$="n"THEN350
298 IFQ$="y"THEN10
299 GOTO296
300 PRINT"{blue}****************************{red}top score{blue}*****************************"
301 POKE36878,15
302 POKE36869,240:RESTORE
305 READA:IFA=-1THEN250
310 POKE36875,A
315 FORQ=1TO100:NEXTQ
320 POKE36875,0
325 GOTO305
350 DATA135,147,159,0,135,147,159,0,135,147,159,0,163,175,0,0,135,147,159,0,135,147,159
355 DATA0,135,147,159,0,175,147,-1
400 END
