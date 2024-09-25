a.out: l7.l l7.y
	bison -d l7.y
	flex l7.l
	g++ -o $@ l7.tab.c lex.yy.c -lfl

clean:
	rm -f l7.tab.c l7.tab.h l7.h lex.yy.c a.out