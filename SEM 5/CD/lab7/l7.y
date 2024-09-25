
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
	unordered_map<string,vector<string>> Ingram;
	unordered_map<string,set<string>> firsts;
	unordered_map<string,set<string>> follows;
	unordered_map<string,bool> nulls;
	unordered_map<string,unordered_map<string,string>> pp_table;

	int i =1;
	unordered_map<int,string> mp;
	unordered_map<int,string> mp2;
	vector<pair<int,vector<string>>>queries;
	vector<string> temp;
	string nt ;
	string alt;
	void CalcFirsts();
	void CalcFollows();
	void CalcPP_Table();
	void processQuery();
	unordered_set<string> CalcFirst_Alpha( string alpha);
	bool isTerminal(string s);
	

	
	


	
	extern char *yytext;
%}

%union {
	char strval[256];
	
}		


%token ARROW GR QR PROD FIRST FOLLOW
%token<strval>  NT TER  EPS
%type<strval> ALT

%%

grammar :  GR productions QR queries
;


productions : production
           | production productions
;
queries : query
		| query queries

		;
query : FIRST NT {queries.push_back(make_pair(1,vector<string>{$2}));}
		| FOLLOW NT {queries.push_back(make_pair(2,vector<string>{$2}));}
		| PROD NT TER{queries.push_back(make_pair(3,vector<string>{$2,$3}));}
		| PROD NT '$' {queries.push_back(make_pair(3,vector<string>{$2,"$"}));}
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
	| EPS {strcpy($$, $1);}
 









%%


bool isTerminal(string s)
{
	if((s[0]>='a' && s[0]<='z')||s[0]=='+'||s[0]=='-'||s[0]=='*'||s[0]=='/'||s[0]=='('||s[0]==')')return true;
	else return false;
}



void CalcFirsts()
{
	int SIZ = Ingram.size();
	for(int x=1;x<=SIZ;x++)
	{
		string non_t=mp2[x];
		nulls[non_t]=false;
	}
	
 bool flag=true;
 while(flag)
 {
	flag=false;
	for(int x=1;x<=SIZ;x++)
	{
		string non_t=mp2[x];
      vector<string> rhs=Ingram[non_t];
		for( auto prod_s : rhs)
		{ 
			bool eps_flag=true;
			string prod = prod_s;
			if(prod=="eps")
			{
				if(firsts[non_t].insert("eps").second){flag=true;nulls[non_t]=true;}continue;
			}
			for (int i=0;i<prod.size();i++)
			{  
				string check = string(1,prod[i]);
			 if(i+1<(prod.size())&&prod[i+1]=='\'')
			 {
				check += '\'';i++;
			 }
				if(isTerminal(check))
				{
					if(firsts[non_t].insert(check).second)flag=true;eps_flag=false;break;
				}
				else
				{  
					if(firsts.find(check)!=firsts.end())
					{
						set<string> temp_f=firsts[check];
						for(auto e : temp_f)
						{
							if(e!="eps")
							{
								if(firsts[non_t].insert(e).second==true)flag=true;
							}
						}
						if(!nulls[check])
						{
							eps_flag=false;break;
						}
						
					}
					else 
					{
						eps_flag=false;break;
					}
				}
			}
			if(eps_flag==true)
			{
				if(firsts[non_t].insert("eps").second){flag=true;nulls[non_t]=true;}
			}  
		}
	}	
 }
}

void Calc1Follows()
{
	int SIZ=Ingram.size();
string startsymbol = mp2[1];
follows[startsymbol].insert("$");
bool flag =true;
while(flag)
{ 
	flag=false;
 for (int x=1;x<=SIZ;x++)
 {
      string non_t=mp2[x];
      vector<string> rhs=Ingram[non_t];
	  for( auto prod_s : rhs )
	  {
          string prod = prod_s;
		  if(prod=="eps")continue;
		  int siz =prod.size();
		  for(int i=0;i<siz;i++)
		  {
			 string check = string(1,prod[i]);
			  if(i+1<(siz)&&prod[i+1]=='\''){check += '\'';i++;}
			  string follow= prod.substr(i+1);
			 if(!isTerminal(check))
			 { 
				if(i!=siz-1)
				{
					unordered_set<string> temp_f = CalcFirst_Alpha(follow);
					for(auto e : temp_f)
					{
						if(e!="eps")
						{
							if(follows[check].insert(e).second)flag=true;
						}
					}
					if(temp_f.find("eps")!=temp_f.end())
					{
						
                        for(auto e : follows[non_t])
					   {
						if(e!="eps")
						{
							if(follows[check].insert(e).second)flag=true;
						}
					   }
						
					}
					
				}
				else
				{
					
					for(auto e : follows[non_t])
					   {
						
						
							if(follows[check].insert(e).second)flag=true;
						
					   }
                  
				}
			  
			 }
		  }
	  }

}
}
}


/* void CalcFollows()
{
int SIZ=Ingram.size();
string startsymbol = mp2[1];
follows[startsymbol].insert("$");
bool flag =true;
while(flag)
{ flag=false;
 for (int x=1;x<=SIZ;x++)
 {
      string non_t=mp2[x];
      vector<string> rhs=Ingram[non_t];
	  for( auto prod_s : rhs )
	  {
          string prod = prod_s;
		  if(prod=="eps")continue;
		  int siz =prod.size();
		  for(int i=0;i<siz;i++)
		  {
			 string check = string(1,prod[i]);
			  if(i+1<(siz)&&prod[i+1]=='\''){check += '\'';i++;}

			 if(!isTerminal(check))
			 {
				if(i!=siz-1)
			  {
				int j=i+1;
				
				while(j<siz)
				{
					string follow = string(1,prod[j]);
					if(j+1<(siz)&&prod[j+1]=='\''){follow += '\'';j++;}

					if(isTerminal(follow))
					{
						if(follows[check].insert(follow).second)flag=true;
						break;
					}
					else
					{
						set<string> temp_f = firsts[follow];
						for(auto e : temp_f)
						{
							if(e!="eps")
							{
								if(follows[check].insert(e).second)flag=true;
							}
						}
						if(!nulls[follow])
						{
							break;
						}
						else
						{
							j++;
						if(j>siz-1)
						{
							set<string> temp_c = follows[non_t];
						for(auto e : temp_c)
						{
							if(e!="eps")
							{
								if(follows[check].insert(e).second)flag=true;
							}
						}
						}
						}
					}
				}
			}

				else
				{
					set<string> temp_c = follows[non_t];
						for(auto e : temp_c)
						{
							if(e!="eps")
							{
								if(follows[check].insert(e).second)flag=true;
							}
						}
				}

			 }

		  }

	  }

 }

}

} */

unordered_set<string> CalcFirst_Alpha(string alpha)

{if(alpha=="eps") return unordered_set<string>{"eps"};
 unordered_set<string> ans;
	int siz = alpha.size();
	
	for(int i=0;i<siz;i++)
	{
		string check = string(1,alpha[i]);
		if(i+1<(siz)&&alpha[i+1]=='\''){check += '\'';i++;}

		if(isTerminal(check))
		{
			ans.insert(check);
			break;
		}
		else
		{
          set<string> temp_f = firsts[check];
		  for(auto e : temp_f)
		  {
			  if(e!="eps")
			  {
				  ans.insert(e);
			  }
		  }
		  if(!nulls[check])
		  {
			  break;
		  }
		  else{
			if(i==siz-1)
			{
				ans.insert("eps");
	        }
		  }
		  
		}
	}
	return ans;
}

void CalcPP_Table()
{ int SIZ=Ingram.size();
string start=mp2[1];
/* pp_table[start]["$"]="Accept"; */
  for (int x=1;x<=SIZ;x++)
 {
      string non_t=mp2[x];
      vector<string> rhs=Ingram[non_t];
	  for( auto prod_s : rhs )
	  {
           unordered_set<string> temp_alpha = CalcFirst_Alpha(prod_s);
		   bool flag=false;
		   for( auto a : temp_alpha)
		   { if(a!="eps")
		   	 {
			   string temp = non_t + "-> " + prod_s;
			   pp_table[non_t][a]=temp;
		     }
			 else flag=true;
		   }
		   if(flag)
		   { set<string> temp_fo=follows[non_t];
		     for(auto b : temp_fo)
			  {
                  string temp = non_t + "-> " + prod_s;
				  pp_table[non_t][b]=temp;

			  }
		   }
		   
	  }
 }

	if(nulls[start])pp_table[start]["$"]="Accept";
}


void processQuery()
{

	for(int i=0;i<queries.size();i++)
	{
         if(queries[i].first==1){
			 string temp = queries[i].second[0];

			 if(firsts[temp].size()!=0)cout << "{";
			 else cout << "{}" << endl;
			 int t=0;
			 int T=firsts[temp].size();
			 for(auto j : firsts[temp])
			 {
				if(t!=T-1) cout << j << ",";
				else cout << j <<"}" <<endl;
				t++;
		     }
		 }
		 else if(queries[i].first==2)
		 {
			 string temp = queries[i].second[0];
			 if(follows[temp].size()!=0)cout << "{";
			 else cout << "{}" << endl;
			 int t=0;
			 int T=follows[temp].size();
			 for(auto j : follows[temp])
			 {
				if(t!=T-1) cout << j << ",";
				else cout << j <<"}" <<endl;
				t++;
			 }
		 }
		 else
		   {
			 string temp = queries[i].second[0];
			 string temp2 = queries[i].second[1];
			 if(pp_table.find(temp)==pp_table.end()||pp_table[temp].find(temp2)==pp_table[temp].end())
			 {
				 cout << "." << endl;
			 }
			 else
			 {
				 cout << pp_table[temp][temp2] << endl;
			 }
			
		 }

	}
}




void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
	exit(1);
}





int main(void) {
 yyparse();
int siz = Ingram.size();
CalcFirsts();
Calc1Follows();
CalcPP_Table();
processQuery();
 /* unordered_set<string> temp_f = CalcFirst_Alpha("BC");
 for(auto e : temp_f)
 {
	 cout << e << endl;
 } */




	return 0;
}

	





