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
    unordered_map<string,int> values;
    unordered_map<string,set<string>>adjlist;
    set<string> current_function;
    bool flag = false;
    stack<bool> if_flags;

    bool Reachable_dfs (string &f, string &g);
    bool Eventually_Recurive (string &f);
    bool Self_Recursive (string &f);
    int Depth (string &f,map<string,bool> &visited,map<string,int> &depth);
    map<string,bool> visited;
    map<string,int> depth;
   
    

  
  
    
%}

%union
{
	char strval[256];
    int ival;
}	

%token<strval> ID
%token<ival> NUM
%token VOID RETURN INT MAIN IF ELSE OR AND EQ END DEAD SELF_RECURSIVE EVENTUALLY_RECURSIVE CO_RECURSIVE DEPTH REACHABLE
%left '+' '-'
%type<strval> Ids
%type<ival> expression primary_expression boolean_primary boolean_expression


%%

program : {if_flags.push(true);} function_defntions main_function END queries
;

function_defntions : 
                    | function_definition function_defntions
;
int_declarations : 
                  | int_declaration int_declarations
;
int_declaration : INT ID ';'
;
function_definition : VOID ID '(' ')'  function_body {adjlist[$2] = current_function; current_function.clear(); values.clear();}
;
function_body :  '{' int_declarations statements RETURN ';' '}'
;
statements : 
              | statement statements
;
statement : assignment_statement
            | if_statements
            | function_call
;
assignment_statement : ID '=' expression ';' { values[$1] = $3; }
;
if_statements : if_statement
               | if_else_statement
;
if_temp : IF '(' boolean_expression ')' {if($3)if_flags.push(true);else if_flags.push(false);}
;
if_statement : if_temp '{' statements '}' {if_flags.pop();}
;
if_else_statement : if_temp '{' statements '}' ELSE {bool temp = if_flags.top();if_flags.pop();if(temp)if_flags.push(false);else if_flags.push(true);} '{' statements '}' {if_flags.pop();}
;            

main_function : INT MAIN '(' ')' main_body {adjlist["main"] = current_function; current_function.clear();values.clear();}
;
main_body : '{' int_declarations statements RETURN  NUM ';' '}'
;
function_call : ID '(' ')' ';' { bool temp= if_flags.top();  if(temp) {current_function.insert($1);}}
;
boolean_expression : boolean_primary { $$ = $1; }
                    | boolean_primary OR boolean_primary {  $$ = $1 || $3; }
                    | boolean_primary AND boolean_primary { $$ = $1 && $3; }
;
boolean_primary :  expression '<' expression { $$ = $1 < $3; }
                    | expression '>' expression { $$ = $1 > $3; }
                    | expression EQ expression { $$ = $1 == $3; }
                    | '(' boolean_expression ')' { $$ = $2; }
;

expression : primary_expression { $$ = $1; }
            | primary_expression '+' primary_expression { $$ = $1 + $3; }
            | primary_expression '-' primary_expression { $$ = $1 - $3; }
;
primary_expression : ID { $$ = values[$1]; }
                    |'-' ID { $$ = -values[$2];}
                    | NUM { $$ = $1; }
                    |'-' NUM { $$ = -$2;}
                    | '(' expression ')' { $$ = $2; }
;
queries : query queries
         | query
;
Ids : ID  {strcpy($$, $1);} 
     | MAIN {strcpy($$, "main");}
;
query :  DEAD Ids {string f = "main";string g= string($2);if(g=="main") cout<<"No"<<endl;else if(!Reachable_dfs(f,g)) cout <<"Yes"<<endl; else cout<<"No"<<endl;}      
        | REACHABLE Ids ',' Ids {string f = string($2);string g= string($4); if(Reachable_dfs(f,g)) cout <<"Yes"<<endl; else cout<<"No"<<endl;}                
        | SELF_RECURSIVE Ids { string f= string($2);if(Self_Recursive(f)) cout <<"Yes"<<endl; else cout<<"No"<<endl;}
        | EVENTUALLY_RECURSIVE Ids {string f= string($2); if(Eventually_Recurive(f)) cout <<"Yes"<<endl; else cout<<"No"<<endl;}
        | CO_RECURSIVE Ids ',' Ids {string f = string($2);string g= string($4);if(adjlist[f].find(g)!=adjlist[f].end() && adjlist[g].find(f)!=adjlist[g].end()) cout <<"Yes"<<endl; else cout<<"No"<<endl;}
        | DEPTH Ids {string f= string($2);cout <<Depth(f,visited,depth)<<endl;visited.clear();depth.clear();}
%%

bool Reachable_dfs(string &f, string &g)
{
    map<string,bool> visited;
    stack<string> vertices;
    vertices.push(f);
   while (!vertices.empty())
   {
     string v = vertices.top();
     visited[v] = true;
        vertices.pop();
        for (auto i:adjlist[v])
        {
            if (i==g)
            {
                return true;
            }
            if(!visited[i])
            {
                
                vertices.push(i);
            }
            
        }

   }
    return false;
    

}
bool Self_Recursive (string &f)
{
    if(adjlist[f].find(f)!=adjlist[f].end())
    {
        return true;
    }
    return false;
}

bool Eventually_Recurive (string &f)
{
    if((!Self_Recursive(f))&&Reachable_dfs(f,f))
    {
        return true;
    }
    return false;
}

int Depth (string &f,map<string,bool> &visited,map<string,int> &depth)
{ visited[f] = true;
    
    if (Self_Recursive(f)||Eventually_Recurive(f))
    {
        depth[f] = -1;
        return -1;
    }
    if (adjlist[f].size()==0)
    {
        depth[f] = 0;
       return 0;
    }
    int max_depth = -1;
    for(auto i:adjlist[f])
    {
        if(!visited[i])
        {
           
            int temp = Depth(i,visited,depth);
            if(temp==-1)
            {
                depth[f]=-1;
                return -1;
            }
            else 
            {
                depth[f]=max(depth[f],temp+1);
            }
            
           
        }
        else 
        {
            depth[f]=max(depth[f],depth[i]+1);
        }
    }

    return depth[f];
    
    

    
  
    

}
   

void yyerror(const char *s) 
{
    fprintf(stderr, "%s\n", s);
    cout <<"failed"<<endl;
	exit(1);
}

int main (void)
{
    yyparse();

    /* for(auto i:adjlist)
    {
        cout<<i.first<<"->";
        for(auto j:i.second)
        {
            cout<<j<<" ";
        }
        cout<<endl;
    } */
}


