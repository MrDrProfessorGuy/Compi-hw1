#ifndef TOKENS_HPP_ 
#define TOKENS_HPP_ 
//#include 
#include <stdio.h>
#include "iostream"
#include <string.h>


extern int yylineno;
extern char* yytext;
//extern int yyleng;
extern int yylex();


extern std::string token_value;

enum tokentype { VOID = 1, INT = 2, BYTE = 3,
                 B = 4, BOOL = 5, AND = 6, OR = 7, 
                 NOT = 8, TRUE = 9, FALSE = 10, RETURN = 11, 
                 IF = 12, ELSE = 13, WHILE = 14, BREAK = 15, 
                 CONTINUE = 16, SC = 17, COMMA = 18, LPAREN = 19, 
                 RPAREN = 20, LBRACE = 21, RBRACE = 22, ASSIGN = 23, 
                 RELOP = 24, BINOP = 25, COMMENT = 26, ID = 27, 
                 NUM = 28, STRING = 29 }; 

extern std::string tokentype_str[];
/*
std::string tokentype_str[] = {"TEST", "VOID", "INT", "BYTE",
                 "B", "BOOL", "AND", "OR", 
                 "NOT", "TRUE", "FALSE", "RETURN", 
                 "IF", "ELSE", "WHILE", "BREAK", 
                 "CONTINUE", "SC", "COMMA", "LPAREN", 
                 "RPAREN", "LBRACE", "RBRACE", "ASSIGN", 
                 "RELOP", "BINOP", "COMMENT", "ID", 
                 "NUM", "STRING"}; 
*/

enum escapeType {Backslash=1, QuotationMark = 2, LF = 3, CR = 4, 
                 TAB = 5, NUL = 6, HEXA = 7, InvalidHexa = 8, InvalidES = 9};


 #endif /* TOKENS_HPP_ */