%{
	#include <stdlib.h>
	#include "l6.tab.h"
	void yyerror(const char *);
	
%}



%%


[A-Z]     {  strcpy(yylval.strval,yytext); return NT;}

"->"      {   return ARROW;}

[a-z]     {  strcpy(yylval.strval,yytext); return TER;}

[+\-*/]    {  strcpy(yylval.strval,yytext); return TER;    }

"|"        {  return *yytext;}

";"          {  return *yytext;}

[ \t\n\r]   {  }

.         {  yyerror("Invalid character");}










%%

int yywrap(void) {
    return 1;
}