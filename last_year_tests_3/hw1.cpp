#include "tokens.hpp"
#include "iostream"

using namespace std;



//extern std::string token_value;





int main(){
	int token;
	while ((token = yylex())) {
	      //printf("%d %s %s\n", yylineno, token, yytext);
		  cout << yylineno << " " << tokentype_str[token] << " " << token_value << endl;
		  flush(cout);
	}
	
	return 0;
}

/*
void appendString(char* token_name){
    string tmp(yytext);
    if (tmp == "\n"){
        code_string.push_back(0xA);
    }
    else{
        code_string.append(tmp);
    }
}

void printString(char* token_name){
    cout << code_string << endl;
}
*/

