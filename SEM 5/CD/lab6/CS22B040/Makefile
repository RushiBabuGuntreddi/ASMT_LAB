a.out: l6.l l6.y
	bison -d l6.y
	flex l6.l
	g++ -o $@ l6.tab.c lex.yy.c -lfl

clean:
	rm -f l6.tab.c l6.tab.h l6.h lex.yy.c a.out
