a.out: l9.l l9.y
	bison -d l9.y
	flex l9.l
	g++ -o $@ l9.tab.c lex.yy.c -lfl

clean:
	rm -f l9.tab.c l9.tab.h l9.h lex.yy.c a.out