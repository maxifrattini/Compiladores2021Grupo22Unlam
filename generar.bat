bison -dyv sintactico.y

flex lexico.l

gcc lex.yy.c y.tab.c -o prueba.exe
pause
primera.exe prueba.txt
pause

del lex.yy.c
del y.tab.c
del y.output
del y.tab.h

pause