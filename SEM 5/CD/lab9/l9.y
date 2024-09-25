%{
    
    #include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include <bits/stdc++.h>
    using namespace std;
    void yyerror(const char *);
	extern char *yytext;
    int yylex(void);
    extern char *yytext;
    map<string,map<pair<string,int>,int>>poly;
    map<string,map<string,int>>values;
    int EValuate_Polynomail(const string &polyname);
    void Print_Poly(const string &polyname);
    string polyname;
    int sign=1;
    
    
%}

%union
{
     int ival;
	char strval[256];
}	

%left '+' '-'
%token<strval> VAR POLY
%token<ival> NUM
%type<strval>expression
%type<strval>term
%type<strval> values value

%%

programm : def_grammar 
;
def_grammar : definitions 
;
definitions : definition 
            | definition definitions
;

definition : POLY {polyname=$1;} '=' expression {}
             | POLY {polyname=$1;} ':' values  {Print_Poly(polyname);} 
          
;

expression : term  {}
            | '+' term {}
            | '-' {sign*=-1;} term  {sign*=-1;}
            | expression '+'  expression { }
            | expression '-' {sign*=-1;} expression {sign*=-1;}
;

term : NUM {poly[polyname][make_pair("const",0)]+=sign*$1;}
      | POLY { for(auto elem:poly[$1])poly[polyname][elem.first]+=sign*elem.second;} 
      | VAR '^' NUM {poly[polyname][make_pair($1,$3)]+=sign*1;}
      | VAR  {poly[polyname][make_pair($1,1)]+=sign*1;}
      | NUM VAR '^' NUM {poly[polyname][make_pair($2,$4)]+=sign*$1;}
      | NUM VAR  {poly[polyname][make_pair($2,1)]+=sign*$1;}
;

values : value {}
        | value ',' values {}
        | {values[polyname]["c"]=0;}
;

value : VAR '=' NUM {values[polyname][$1]=$3;}
       | VAR '=' '-' NUM {values[polyname][$1]=-1*$4;}
;

%%


void yyerror(const char *s) 
{
    fprintf(stderr, "%s\n", s);
	exit(1);
}


int EValuate_Polynomail(const string &polyname)
{
    int ans=0;
    map<string,int>Value_xyz=values[polyname];
    for(auto e_term :poly[polyname])
    {
        string xyz= (e_term.first).first;
        int power=(e_term.first).second;
        int coff=e_term.second;
        if(xyz=="const")
        {
            ans+=coff;
        }
        else
        {
            ans+=coff*(pow(Value_xyz[xyz],power));
        }
    }
    return ans;
}

void Print_Poly(const string &polyname)
{
    cout<<polyname<<": "<<EValuate_Polynomail(polyname)<<endl;
}


int main(void)
{
  yyparse();
  return 0;
}




