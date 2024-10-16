%{

    #include <stdio.h>
    #include "l12.tab.h"
    void yyerror(const char *);


%}

%%


"if"  {return IF;}

"else" {return ELSE;}

"void" {return VOID;}

"main" {return MAIN;}

"int" {return INT;}

"return" {return RETURN;}

"DEAD"     {return DEAD;}

"REACHABLE" {return REACHABLE;}

"SELF-RECURSIVE" {return SELF_RECURSIVE;}

"EVENTUALLY-RECURSIVE" {return EVENTUALLY_RECURSIVE;}

"CO-RECURSIVE" {return CO_RECURSIVE;}

"DEPTH" {return DEPTH;}

[a-z_A-Z][a-z_A-Z0-9]* { strcpy(yylval.strval,yytext); return ID;}

[0-9]+    { yylval.ival = atoi(yytext); return NUM;}

[\(\)\{\}\>\<\=\+\-\;\,]   { return *yytext;}
"%%"  { return END;}

"=="   { return EQ;}

"&&"   { return AND;}

"||"   { return OR;}

[ \t\n\r]   {   }

.           {yyerror(yytext);} 

%%


int yywrap(void) {
    return 1;
}