0 ' HORSES1.BAS
1 '
2 ' 25 horses
3 ' Race up to 5 at a time
4 ' Find the fastest horse
5 '
10 ' H(x) - horse speed
15 DIM H(24)
20 '
21 ' Initialize each speed
22 '
25 FOR I=0 TO 24:H(I)=I:NEXT
30 '
31 ' Randomize
32 '
35 FOR I=0 TO 24
40 IF I/5=INT(I/5) THEN PRINT
45 J=I+INT(RND(25-I)-1)
50 T=H(I)
55 H(I)=H(J)
60 H(J)=T
65 PRINT H(I);
70 NEXT
75 PRINT:PRINT "RACE!"
100 '
101 ' Find fastest horse
102 '
105 DIM FH(4)
110 '
111 ' Race five sets of five
112 ' FH(x) - fastest horse
113 ' FS(x) - and its speed
114 '
115 FOR R=0 TO 4
120 FH(R)=-1:FS=-1
125 PRINT R;"-";
130 FOR I=R*5 TO R*5+4
135 PRINT I;
140 IF H(I)>FS THEN FH(R)=I:FS=H(I)
145 NEXT
150 PRINT "=";FH(R)
155 NEXT
160 '
161 ' Race the five winners
162 '
165 FH=-1:FS=-1
170 PRINT " F -";
175 FOR I=0 TO 4
180 PRINT FH(I);
185 IF H(FH(I))>FS THEN FH=FH(I):FS=H(FH)
190 NEXT
195 PRINT "=";FH
200 PRINT "WINNER IS HORSE";FH
500 END
