%{

    #include <stdio.h>
    #include "l10.tab.h"
    void yyerror(const char *);


%}

%%


"if"  {return IF;}

"print" {return PRINT;}

"else" {return ELSE;}

"while" { return WHILE;}

[a-z_A-Z]+ { strcpy(yylval.strval,yytext); return VAR;}

[0-9]+    {  strcpy(yylval.strval,yytext);return NUM;}

[\(\)\=\{\}\<\+\-]   { return *yytext;}

[ \t\n\r]   {   }

.           {yyerror(yytext);} 

%%


int yywrap(void) {
    return 1;
}