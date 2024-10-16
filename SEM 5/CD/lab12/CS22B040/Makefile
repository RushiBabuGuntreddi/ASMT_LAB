a.out: l12.l l12.y
	bison -d l12.y
	flex l12.l
	g++ -o $@ l12.tab.c lex.yy.c -lfl

clean:
	rm -f l12.tab.c l12.tab.h l12.h lex.yy.c a.out