
%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include <bits/stdc++.h>
	using namespace std;
	#include <map>
	void yyerror(const char *);
	extern char *yytext;
	int yylex(void);
	map<string,vector<string>> Ingram;
	int i =1;
	unordered_map<int,string> mp;
	unordered_map<int,string> mp2;
	vector<string> temp;
	string nt ;
	string alt;
	
	


	
	extern char *yytext;
%}

%union {
	char strval[256];
	
}		


%token ARROW 
%token<strval>  NT TER
%type<strval> ALT

%%

grammar : productions
;


productions : production
           | production productions
;

production : NT {nt= $1;mp2[i]=nt;i++;} ARROW ALTLIST ';' 
;
ALTLIST : ALT {Ingram[nt].push_back(string($1));}
		| ALTLIST '|' ALT {Ingram[nt].push_back(string($3));}
;

ALT : ALT TER {strcpy($$, $1);strcat($$, $2);}
    | ALT NT {strcpy($$, $1);strcat($$, $2);}
	| TER {strcpy($$, $1);}
	| NT { strcpy($$, $1);}










%%





void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
	exit(1);
}

int main(void) {
    yyparse();
	int order =1;


int p=Ingram.size();
for (int i=1;i<p+1;i++)
{
		string A_i,A_j;
		A_i=mp2[i];
		
		
for (int j=1;j<i;j++)
{vector<string> replace;
        A_j=mp2[j];
	
	
for (auto elem : Ingram[A_i])
{

if (elem[0]==A_j[0])
{
     for( auto elem2 : Ingram[A_j])
	 {
         replace.push_back(elem2+elem.substr(1));
      
		
	  }
}
else 
{
      replace.push_back(elem);
}
	  
}
Ingram[A_i]=replace;
}
vector<string>alphas;
vector<string>betas;
for (auto elem : Ingram[A_i])
{
	if(elem[0]==A_i[0])
	{  
		alphas.push_back(elem.substr(1));
		
	}
	else 
	{
		betas.push_back(elem);
		
	}

}

vector<string>temp1;
vector<string>temp2;
if(alphas.size()!=0)
{


for (auto elem : betas)
{ string nA_i= A_i + "\'";

	temp1.push_back(elem+nA_i);

}
Ingram[A_i]=temp1;
mp[order]=A_i;order++;
for (auto elem : alphas)
{
	string nA_i= A_i + "\'";
	temp2.push_back(elem+nA_i);
}
temp2.push_back("eps");
Ingram[A_i+"\'"]=temp2;
mp[order]=A_i+"\'";order++;
}
else
{
	Ingram[A_i]=betas;
	mp[order]=A_i;order++;
}


}
int siz = Ingram.size();

	
	


	for (auto i : Ingram) {
		
		cout << i.first << " -> ";
		vector<string> vec = i.second;
		for(int i=0;i<vec.size();i++)
		{
			if(i!=vec.size()-1)
			{
				cout << vec[i] << " | ";
			}
			else
			{
				cout << vec[i]<<";";
			}
		}
		cout << endl;	
	
	}
	return 0;
}
	






