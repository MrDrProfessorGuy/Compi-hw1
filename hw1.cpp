#include "tokens.hpp"
#include "iostream"

using namespace std;









int main(){
	int token;
	while ((token = yylex())) {
	      //printf("%d %s %s\n", yylineno, token, yytext);
		  cout << yylineno << " " << token << " " << yytext << endl;
	}
	
	return 0;
}





