%{
	#include <stdlib.h>
	#include "l7.tab.h"
	void yyerror(const char *);
	
%}



%%


[A-Z](\')?     {  strcpy(yylval.strval,yytext); return NT;}

"->"      {   return ARROW;}

"GRAMMAR" {  return GR;}
"QUERY" {  return QR;}
"FIRST"  {  return FIRST;}
"FOLLOW" {  return FOLLOW;}
"PROD"   {  return PROD;}
"$"      { return *yytext;}
[a-z]     {  strcpy(yylval.strval,yytext); return TER;}

"eps"     {strcpy(yylval.strval,yytext); return EPS;}

[+\-*/\(\)]   {  strcpy(yylval.strval,yytext); return TER;    }

"|"        {  return *yytext;}

";"          {  return *yytext;}

[ \t\n\r]   {  }

.         {  yyerror("Invalid character");}










%%

int yywrap(void) {
    return 1;
}