%{

    #include <stdio.h>
    #include "l9.tab.h"
    void yyerror(const char *);


%}


%%

[xyz]       {strcpy(yylval.strval,yytext); return VAR;}

[p][1-9]+   {strcpy(yylval.strval,yytext);return POLY;}

[0-9]+  {  yylval.ival=atoi(yytext);return NUM;}

[+\-\=\,\:]       { return *yytext;}

"^"         { return *yytext;}

[ \t\n\r]   {  }

.           {yyerror("Invalid character");} 

%%


int yywrap(void) {
    return 1;
}