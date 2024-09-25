a.out: l8.l l8.y
	bison -d l8.y
	flex l8.l
	g++ -o $@ l8.tab.c lex.yy.c -lfl

clean:
	rm -f l8.tab.c l8.tab.h l8.h lex.yy.c a.out
