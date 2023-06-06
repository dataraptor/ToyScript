
bison -d toy.y && flex toy.l && gcc toy.tab.c lex.yy.c -lm -o toy && ./toy toyprog.txt

