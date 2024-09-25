%{
	#include <stdlib.h>
	#include "l8.tab.h"
	void yyerror(const char *);
	
%}



%%

[a-z]      {   strcpy(yylval.strval,yytext);  return  VAR; }
"&"        {return *yytext;}
"|"        {return *yytext;}
"("        {return *yytext;}
")"        {return *yytext;}
"~"        {return *yytext;}













[ \t\n\r]   {  }

.         {  yyerror("Invalid character");}










%%

int yywrap(void) {
    return 1;
}