
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
	extern char *yytext;
    set<string> var_order;
    unordered_map<string,int> mp;
    unordered_map<int,string> mp2;
    vector<set<string>> dnf;
    set<string> onepaths;
    
    set<string> conjuct;
    class Node{
        public:
        string var;
        Node* left;
        Node* right;
       set< Node *> parents;
        Node(string s){
            this->var = s;
            this->left = NULL;
            this->right = NULL;
            
        }
    }
    ;
     

    void print_tree(Node* root, int depth);
    void print_edges(Node* node);
    map<string,vector<Node *>> nodes;
    
class BinaryTree
{
        public:
        Node* root; 
        Node* zeronode = new Node("0");
        Node* onenode = new Node("1");     
        BinaryTree()
        {
            root = NULL; 
   
        }

        Node * create_BDT(unordered_map<int,string> &mp2,set<string> &onepaths,int ind,string path)
        {
            if(ind==mp2.size())
            {
             
                if(onepaths.find(path)!=onepaths.end())
                {
                    return onenode;
                }
                else
                {
                    return zeronode;
                }
            }
            Node *root = new Node(mp2[ind]);
            
            root->left = create_BDT(mp2,onepaths,ind+1,path+"0");
            root->right = create_BDT(mp2,onepaths,ind+1,path+"1");
            if(root->left)root->left->parents.insert(root);
            if(root->right)root->right->parents.insert(root);   
            nodes[mp2[ind]].push_back(root);
            return root;

        }



        

void reduce_bdd()
{
     bool changed =true;
     int size =mp2.size()-1;   
    while(changed)
    {
        changed=false;
     for (int i = size; i >= 0; i--)
     {
            set<int>removed;
            string temp = mp2[i];
            int temp_siz=nodes[temp].size();
            if(temp_siz>1)
            {
                for(int j=0;j<temp_siz-1;j++)
                {
                    if(removed.find(j)!=removed.end())continue;
                    for(int k=j+1;k<temp_siz;k++)
                    {
                        if(removed.find(k)!=removed.end())continue;
                        Node *n1=nodes[temp][j];
                        Node *n2=nodes[temp][k];
                        if((n1->left == n2->left) && (n1->right == n2->right))
                        {
                            removed.insert(k);
                            changed=true;
                        for(auto parent : n2->parents)
                        {
                          if (parent->left == n2)
                          {
                            parent->left = n1;
                          } 
                          else
                          {
                           parent->right = n1;
                          }
                            n1->parents.insert(parent);     
                        }   
                            n2->parents.clear();
                            delete n2;
                        }

                    }
                }

                for (auto it = removed.rbegin(); it != removed.rend(); ++it)
                {
                  if (*it < nodes[temp].size())
                  {
                    nodes[temp].erase(nodes[temp].begin() + *it);
                  }
                }
            }
              removed.clear();
              temp_siz = nodes[temp].size();

             for (int j = 0; j < temp_siz; j++)
             {
                if(removed.find(j)!=removed.end())continue;
                Node *n=nodes[temp][j];
                if(n->left == n->right)
                {   changed=true;
                    removed.insert(j);
                    if(n==root)
                    {
                        root=n->left;
                        if(root)root->parents.clear();
                    }
                    else
                    {
                     for(auto parent : n->parents)
                     {                    
                        if (parent->left == n)
                        {
                          parent->left = n->left;
                        } 
                        if(parent->right == n)
                        {
                          parent->right = n->left;
                        }
                        if(n->left) n->left->parents.insert(parent);
                     }
                
                    }
                    n->parents.clear();
                    delete n;
                }
             }
                for( auto it=removed.rbegin();it!=removed.rend();it++)
                {
                    if(*it<nodes[temp].size())
                    {
                    nodes[temp].erase(nodes[temp].begin()+*it);
                    }
                }
                
     }
    }



}


    
};


void print_edges(map<string,vector<Node *>> &nodes){
    for(auto e : nodes)
    {
        for(auto f : e.second)
        {
            if(f->left)
            {
                cout<<"("<<e.first<<", 0) -> "<<f->left->var<<endl;
            }
            if(f->right)
            {
                cout<<"("<<e.first<<", 1) -> "<<f->right->var<<endl;
            }
        }
    }
}

    void print_tree(Node* root, int depth)
    {
        if(root == nullptr)
        {
            return;
        }

        print_tree(root->right, depth + 1);
        for(int i = 0; i < depth; i++)
        {
            cout << "    ";
        }
        cout << root->var << endl;
        print_tree(root->left, depth+1);
        
    }
 
%}

%union {
    char strval[256];
  
}

%token  '|' '&' '~' '(' ')' 
%token<strval> VAR
%type<strval>  lit   

%%
input : dnf 
    
;
dnf : '(' conjuct ')' {dnf.push_back(conjuct);conjuct.clear();} 
    | dnf  '|' '(' conjuct ')'   {dnf.push_back(conjuct);conjuct.clear();} 
;
conjuct : lit {conjuct.insert($1);} 
    | conjuct '&' lit { conjuct.insert($3);}
    ;
lit : VAR { strcpy($$, $1);var_order.insert($1);}
    | '~' VAR { strcpy($$, "~");strcat($$, $2);var_order.insert($2);}
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
	exit(1);
}

int main(void) {
 yyparse();
 int ind=0;
    for(auto e : var_order){
        mp[e]=ind;
        mp2[ind]=e;
        ind++;
    }
 int siz=var_order.size();
 for(auto e : dnf){
    string s(siz,'\0');
     for(auto f : e){
         if(f[0]=='~'){
             s[mp[f.substr(1)]]='0';
         }
         else{
             s[mp[f]]='1';
         }
     }
     onepaths.insert(s);
 }

BinaryTree *bdt= new BinaryTree();
bdt->root = bdt->create_BDT(mp2,onepaths,0,"");
bdt->reduce_bdd();
print_edges(nodes);

 return 0;
}