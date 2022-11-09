%{

/* Declarations section */
#include <stdio.h>
#include "tokens.hpp"

#include "iostream"

using namespace std;

string code_string = "";


void showToken(char* token_name);
void newString(char* token_name);
void printString(char* token_name);
void appendString(int token_name);

//token_illegal   ("{printable}*\\[{printable}*-[n|r|t|0|x{hexa}{hexa}]]"|"{printable}*"{printable}+|"\\n"|"\\r")
//token_string    ("[{printable}*-[{token_illegal}]]")


%}

%option yylineno
%option noyywrap
digit   		([0-9])
hexa            ([0-9A-Ea-e])
letter  		([a-zA-Z])
alphanumeric    ([a-zA-Z0-9])
whitespace		([\t\n ])
printable       ([ -~])
printable_str   ([ -!#-\[\]-~])
good_escape_sequence    (\\\\|\\"|\\n|\\r|\\t|\\0|\\x[0-9][0-9])

token_void      (void)
token_int       (int)
token_byte      (byte)
token_b         (b)
token_bool      (bool)
token_and       (and)
token_or        (or)
token_not       (not)
token_true      (true)
token_false     (false)
token_return    (return)
token_if        (if)
token_else      (else)
token_while     (while)
token_break     (break)
token_continue  (contiue)
token_sc        (;)
token_comma     (,)
token_lparen    (\()
token_rparen    (\))
token_lbrace    (\{)
token_rbrace    (\})
token_assign    (=)
token_relop     (==|!=|<|>|<=|>=)
token_binop     (\+|\-|\*|\/)

token_comment   (\/\/.*)
token_id        ({letter}{alphanumeric}*)
token_num       (0|[1-9]{digit}*)
escape_1        (\\\\)
escape_2        (\\\")
escape_3        (\\n)
escape_4        (\\r)
escape_5        (\\t)
escape_6        (\\0)
escape_7        (\\x{hexa}{hexa})
legal_escape    ({escape_1}|{escape_2}|{escape_3}|{escape_4}|{escape_5}|{escape_6}|{escape_7})

%x STR_NICE


%%

{token_void}      return VOID;
{token_int}       return INT;
{token_byte}      return BYTE;
{token_b}         return B;
{token_bool}      return BOOL;
{token_and}       return AND;
{token_or}        return OR;
{token_not}       return NOT;
{token_true}      return TRUE;
{token_false}     return FALSE;
{token_return}    return RETURN;
{token_if}        return IF;
{token_else}      return ELSE;
{token_while}     return WHILE;
{token_break}     return BREAK;
{token_continue}  return CONTINUE;
{token_sc}        return SC;
{token_comma}     return COMMA;
{token_lparen}    return LPAREN;
{token_rparen}    return RPAREN;
{token_lbrace}    return LBRACE;
{token_rbrace}    return RBRACE;
{token_assign}    return ASSIGN;
{token_relop}     return RELOP;
{token_binop}     return BINOP;
{token_comment}   return COMMENT;
{token_id}        return ID;
{token_num}       return NUM;
\"                BEGIN(STR_NICE);newString("");
<STR_NICE>\"      BEGIN(INITIAL);printString("");
<STR_NICE>{printable_str}   appendString(0);
<STR_NICE>{escape_1}   appendString(1);
<STR_NICE>{escape_2}   appendString(2);
<STR_NICE>{escape_3}   appendString(3);
<STR_NICE>{escape_4}   appendString(4);
<STR_NICE>{escape_5}   appendString(5);
<STR_NICE>{escape_6}   appendString(6);
<STR_NICE>{escape_7}   appendString(7);
<STR_NICE>.   showToken("Log::UnknownString:: ");
{whitespace}                ;
.		printf("Lex doesn't know what that is!\n");

%%

void showToken(char* token_name){
    printf("%d %s %s \n", yylineno, token_name, yytext);
    //cout << yylineno << " " << token_name << " " << yytext << endl;
    
}

void newString(char* token_name){
    code_string = "";
}

void appendString(int token_name){
    string tmp(yytext);
    
    if (token_name == 3){
        code_string.push_back('\n');
    }
    else{
        code_string.append(tmp);
    }
}


void printString(char* token_name){
    printf("%s \n", code_string.c_str());
    //cout << code_string << endl;
}


/*
<STR_NICE>{legal_escape}      showToken("legal_escape:: ");
<STR_NICE>{printable_str}   showToken("");
<STR_NICE>\\      printf("Log::ILLIGAL \\");
<STR_NICE>.       showToken("Log::Unknown string");

*/