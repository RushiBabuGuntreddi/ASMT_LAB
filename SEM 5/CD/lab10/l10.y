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
    int k=0;
   map<string,int> use;
   int scope_num = 0;
   map<int,map<string,int>> all_scope;
   int val = 1;
   int factor =1;
   void process_if (int val); 
   void process_if_else () ;
   void print();
  
    
%}

%union
{
	char strval[256];
}	


%token<strval> VAR NUM
%token IF ELSE WHILE  PRINT

%%
programm : lines {}  NUM {k=atoi($3);}

lines : oneline
        | oneline lines
;
oneline : VAR '=' expr  {all_scope[scope_num][$1] +=1;}
        | PRINT VAR {all_scope[scope_num][$2] +=1;}
        | ifs 
        | ifelses 
        | whiles
;

expr : expr '+' expr | expr '-' expr 
        | NUM 
        | VAR {all_scope[scope_num][$1] +=1;}
;
block : '{' {scope_num++;} lines '}' 
            | '{' {scope_num++;} '}' 

ifs : IF '(' cond ')' block {process_if(1);}
;

ifelses : IF '(' cond ')' block {
                        // current_scope.clear();
                        // current_scope=all_scope[scope_num];
                        // all_scope.erase(scope_num);scope_num--; 
                        } ELSE block {
                            // current_scope2.clear();
                            // current_scope2=all_scope[scope_num];  
                            // all_scope.erase(scope_num);
                            // scope_num--;
                            process_if_else();
                            }
                                                                                                                                                                                            
;


whiles : WHILE '(' {factor=11;} cond {factor=1;} ')'  block {process_if(10);}
         
;
cond : VAR '<' VAR {all_scope[scope_num][$1] +=factor;all_scope[scope_num][$3] +=factor;}
    | NUM '<' VAR {all_scope[scope_num][$3] +=factor;} 
    | VAR '<' NUM {all_scope[scope_num][$1] +=factor;} 
    | NUM '<' NUM
;

%%

void process_if (int val)
{
     
     
    map<string,int> current_scope= all_scope[scope_num];
     all_scope.erase(scope_num);scope_num--;
     for(auto i:current_scope)
     {
         all_scope[scope_num][i.first] += val*i.second;
     }
                                                        
}

void process_if_else ()
{
    map<string,int> temp1= all_scope[scope_num];
    map<string,int> temp2= all_scope[scope_num-1];
    all_scope.erase(scope_num);scope_num--;
    all_scope.erase(scope_num);scope_num--;
    for(auto i:temp1)
  {
     temp2[i.first] = max(temp2[i.first],i.second);
  }

  for(auto i:temp2)
 {
     all_scope[scope_num][i.first] += i.second;
 }
}


void print()
{
    use=all_scope[0];
    for(auto i:use)
    {
        if(i.second>0)
        {
            cout<<i.first<<" "<<i.second<<endl;
        }
    }
}

void yyerror(const char *s) 
{
    fprintf(stderr, "%s\n", s);
	exit(1);
}

int main (void)
{
    yyparse();
    print();
}


