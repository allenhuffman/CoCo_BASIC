10 ' Set high-res graphics, clear screen, activate graphics mode
20 PMODE 4,1:PCLS:SCREEN 1,1
30 ' Set drawing color to bright white
40 COLOR 7
50 ' Draw a filled white box directly
60 LINE (0,0)-(255,191),PSET,BF
70 ' Loop so screen stays displayed
80 GOTO 80
