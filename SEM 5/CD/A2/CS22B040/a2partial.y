%{
	#include <iostream>
	#include <string.h>
	#include <stdlib.h>
    #include <vector>
    #include <bits/stdc++.h>
    using namespace std;
	void yyerror(const char *);
	int yylex(void);
    extern char *yytext;
    string lvalue;
    int dimension;
    int line_number = 1;
    unordered_map<string, int> func_params;
    unordered_map<string, vector<string>> func_params_args;
    stack<string> func_call_stack;
    stack<string> ifs;
    stack<string> elses;
    stack<string>exits;
    int ifs_num=1;
    string generate (const string s,int &val);
    
    int global=0;
    string func_name;
    string func_call_name;
    string t ="t";
    string if_label;
    string else_label;
    string exit_label;
    int t_number=1;
%}

%union {
    int int_val;
    char char_val;
    char *str_val;  
}


%token<str_val> IDENTIFIER STRING_LITERAL INT_CONST CHAR_CONST

%token IF ELSE WHILE FOR RETURN PRINTF
%token INT CHAR 
%token EQ_OP NE_OP LE_OP GE_OP OR AND
%token EXP_OP 
/* %left OR
%left  AND */

%type<str_val> variable expression rvalue constant arithmetic_expression function_call comparison_expression
%right  '<' '>' EQ_OP NE_OP LE_OP GE_OP
%left   '+' '-'
%left   '*' '/'
%left   EXP_OP

%start program

%%

program: lines

lines:
    oneline
    | lines oneline 

oneline:
    variable_declaration ';'
    | function_declaration

type_specifier:  INT
    | CHAR

;

variable_declaration:
    type_specifier declaration_list

function_declaration:
    type_specifier IDENTIFIER {cout<<$2<<":"<<endl;func_name=$2;} '('  parameter_list ')' '{' statements '}' {cout<<endl;}


declaration_list:
    declaration_list ',' variable 
    | declaration_list ',' assignment_statement
    | variable 
    | assignment_statement

variable: 
    IDENTIFIER { $$=$1; }
    | IDENTIFIER '[' expression ']' {strcpy($$,$1);strcat($$,"[");strcat($$,$3);strcat($$,"]");} 

parameter_list:
    | parameter_list ',' function_parameter
    | function_parameter

function_parameter:
    type_specifier IDENTIFIER {int num=++func_params[func_name];string temp = "param" +to_string(num); cout << $2 <<" = "<<temp<<endl; }
    | type_specifier IDENTIFIER '[' function_array_1D ']'

function_array_1D: 
    | expression

statements: 
    | statements statement
 
statement:
    assignment_statement ';'    
    | condition_statement       
    | iteration_statement       
    | return_statement ';'      
    | printf_statement ';'
    | variable_declaration ';'  
    | function_call ';'         

assignment_statement:
    variable '=' expression { if($3[0]=='t'|| $3=="retval"){cout << $1 << " = " << $3 << endl;}else {string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $3 <<endl;cout << $1 << " = " << temp << endl;}  }

condition_statement:
    IF '(' condition_list ')' {{cout<<if_label<<":"<<endl;}}  body {exit_label=generate("L",ifs_num);cout<<"goto "<<exit_label<<endl;} ELSE {{cout<<else_label<<" :"<<endl;}} body {{cout<<exit_label<<" :"<<endl;if_label="";else_label="";exit_label="";}}
    | IF  '(' condition_list ')' body

;
condition_list:
    expression {{ string label;if(if_label=="")if_label=generate("L",ifs_num);label=if_label;cout << "if " << "(" <<$1 <<")"<< " goto " << label << endl; }} OR condition_list 
    | expression {{string label = generate("L",ifs_num); cout << "if " << "(" <<$1 <<")"<< " goto " << label << endl;if(else_label=="")else_label=generate("L",ifs_num);cout << "goto " << else_label << endl;cout <<label<<" :"<<endl; }} AND condition_list 
    | expression {string label;if(if_label=="")if_label=generate("L",ifs_num);label=if_label;cout << "if " << "(" <<$1 <<")"<< " goto " << label << endl;if(else_label=="")else_label=generate("L",ifs_num);cout << "goto " << else_label << endl; }

condition: 
    condition_expression EQ_OP condition_expression
    | condition_expression NE_OP condition_expression
    | condition_expression LE_OP condition_expression
    | condition_expression GE_OP condition_expression
    | condition_expression '<' condition_expression
    | condition_expression '>' condition_expression

condition_expression:
    constant 
    | variable 
    | condition_expression '+' condition_expression
    | condition_expression '-' condition_expression
    | condition_expression '*' condition_expression
    | condition_expression '/' condition_expression
    | condition_expression EXP_OP condition_expression

body:
    '{' statements '}'
    | statement

iteration_statement:
    WHILE {exit_label=generate("L",ifs_num);cout << exit_label<<": "<<endl;}'(' condition_list ')' {{cout<<if_label<<":"<<endl;}} body {{cout<<"goto "<<exit_label<<endl;cout<<else_label<<" :"<<endl;if_label="";else_label="";exit_label="";}}
    | FOR '(' for_assign ';' for_condition ';' for_change ')' body

for_assign:
    | assignment_statement
    | type_specifier assignment_statement

for_condition:
    | condition

for_change:  assignment_statement

return_statement: RETURN expression { cout << "retval = " << $2 << endl;cout<<"return"<<endl; }

printf_statement:
    PRINTF '(' STRING_LITERAL print_parameters ')'

print_parameters:
    | ',' rvalue print_parameters
 
expression:
    rvalue { $$=$1; }
    | function_call { $$=$1; }
    | '(' expression ')' { $$=$2; }
    | arithmetic_expression { $$=$1; }
    | comparison_expression { $$=$1; }

arithmetic_expression:
     expression '+' expression { string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $1 << " + " << $3 << endl; strcpy($$,temp.c_str()) ;}
    | expression '-' expression { string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $1 << " - " << $3 << endl; strcpy($$,temp.c_str()) ;}
    | expression '*' expression { string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $1 << " * " << $3 << endl; strcpy($$,temp.c_str()) ;}
    | expression '/' expression {string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $1 << " / " << $3 << endl; strcpy($$,temp.c_str()) ;}
    | expression EXP_OP expression {string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $1 << " ** " << $3 << endl; strcpy($$,temp.c_str()) ;}

comparison_expression:
    expression EQ_OP expression {string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $1 << " == " << $3 << endl; strcpy($$,temp.c_str()) ;}
    | expression NE_OP expression {string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $1 << " != " << $3 << endl; strcpy($$,temp.c_str()) ;}
    | expression LE_OP expression {string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $1 << " <= " << $3 << endl; strcpy($$,temp.c_str()) ;}
    | expression GE_OP expression {string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $1 << " >= " << $3 << endl; strcpy($$,temp.c_str()) ;}
    | expression '<' expression  {string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $1 << " < " << $3 << endl; strcpy($$,temp.c_str()) ;}
    | expression '>' expression {string temp = t + to_string(t_number); t_number++; cout << temp <<" = "<< $1 << " > " << $3 << endl; strcpy($$,temp.c_str()) ;}

function_call:
    IDENTIFIER {func_call_stack.push($1);} '(' function_call_params ')' 
    { 
    func_call_stack.pop();
        for (int i=1;i<=func_params_args[func_call_name].size();i++)
    {
   string param = "param" + to_string(i);
   cout << param << " = " << func_params_args[func_call_name][i-1] << endl;

    } 
    cout << "call " << func_call_name << endl;
    $$="retval";
    }
;
function_call_params:
    | function_call_params ',' expression {func_call_name=func_call_stack.top();if($3[0]=='t'){func_params_args[func_call_name].push_back($3);}else {string temp = t + to_string(t_number); t_number++;cout << temp <<" = "<<$3<<endl;func_params_args[func_call_name].push_back(temp);} }
    | expression {func_call_name=func_call_stack.top();if($1[0]=='t'){func_params_args[func_call_name].push_back($1);}else {string temp = t + to_string(t_number); t_number++;cout << temp <<" = "<<$1<<endl;func_params_args[func_call_name].push_back(temp);} }
;


constant: INT_CONST  {  $$=$1; }
    | CHAR_CONST { $$=$1; }

rvalue: variable { $$=$1; }
    | constant { $$=$1; }

%%


string generate (const string s,int &val){
    string temp = s + to_string(val);
    val++;
    return temp;
}
void yyerror(const char *s) {
    fprintf(stderr, "hi%d\n", line_number);
    exit(1);
}

int main() {
    yyparse();
    return 0;
}