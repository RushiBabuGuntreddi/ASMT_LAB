a.out: l10.l l10.y
	bison -d l10.y
	flex l10.l
	g++ -o $@ l10.tab.c lex.yy.c -lfl

clean:
	rm -f l10.tab.c l10.tab.h l10.h lex.yy.c a.out