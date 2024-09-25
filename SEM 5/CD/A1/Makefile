a.out: CS22B040.l CS22B040.y
	bison -d CS22B040.y
	flex CS22B040.l
	g++ -o $@ CS22B040.tab.c lex.yy.c -lfl

clean:
	rm -f CS22B040.tab.c CS22B040.tab.h lex.yy.c a.out
