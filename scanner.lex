%{

/* Declarations section */
#include <stdio.h>
#include "tokens.hpp"
#include "iostream"

#define newToken(token_type) token_value = yytext;return token_type;
#define Comment token_value = "\\\\"; return COMMENT;

using namespace std;

std::string token_value;

std::string tokentype_str[] = {"TEST", "VOID", "INT", "BYTE",
                 "B", "BOOL", "AND", "OR", 
                 "NOT", "TRUE", "FALSE", "RETURN", 
                 "IF", "ELSE", "WHILE", "BREAK", 
                 "CONTINUE", "SC", "COMMA", "LPAREN", 
                 "RPAREN", "LBRACE", "RBRACE", "ASSIGN", 
                 "RELOP", "BINOP", "COMMENT", "ID", 
                 "NUM", "STRING"}; 

void showToken(char* token_name);
void newString(char* token_name);
void printString(char* token_name);
void appendString(int token_name);
void str_es(int escapeSequence_type);
//int newToken(int token_type);

//token_illegal   ("{printable}*\\[{printable}*-[n|r|t|0|x{hexa}{hexa}]]"|"{printable}*"{printable}+|"\\n"|"\\r")
//token_string    ("[{printable}*-[{token_illegal}]]")


%}

%option yylineno
%option noyywrap
digit   		([0-9])
hexa            ([0-9A-Fa-f])
letter  		([a-zA-Z])
alphanumeric    ([a-zA-Z0-9])
whitespace		([\t\n ])
newLine         (\xA)
printable       ([ -~])
printable_str   ([ -!#-\[\]-~]|\x09)
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
rule            ([\n\t])
rule2           ([^{rule}])
token_comment   (\/\/.*)
token_id        ({letter}{alphanumeric}*)
token_num       (0|[1-9]{digit}*)
escape_1        (\\)
escape_2        (\")
escape_3        (n)
escape_4        (r)
escape_5        (t)
escape_6        (0)
escape_7        (x{hexa}{hexa})
escape_hexa     ([0-7]{hexa})
escape_bad_hexa        (x[^{hexa}]{hexa}|x[^{hexa}][^{hexa}]|x{hexa}[^{hexa}])
legal_escape    ({escape_1}|{escape_2}|{escape_3}|{escape_4}|{escape_5}|{escape_6}|{escape_7})

%x STR
%x STR_ES
%x STR_HEX


%%

{token_void}      newToken(VOID);
{token_int}       newToken(INT);
{token_byte}      newToken(BYTE);
{token_b}         newToken(B);
{token_bool}      newToken(BOOL);
{token_and}       newToken(AND);
{token_or}        newToken(OR);
{token_not}       newToken(NOT);
{token_true}      newToken(TRUE);
{token_false}     newToken(FALSE);
{token_return}    newToken(RETURN);
{token_if}        newToken(IF);
{token_else}      newToken(ELSE);
{token_while}     newToken(WHILE);
{token_break}     newToken(BREAK);
{token_continue}  newToken(CONTINUE);
{token_sc}        newToken(SC);
{token_comma}     newToken(COMMA);
{token_lparen}    newToken(LPAREN);
{token_rparen}    newToken(RPAREN);
{token_lbrace}    newToken(LBRACE);
{token_rbrace}    newToken(RBRACE);
{token_assign}    newToken(ASSIGN);
{token_relop}     newToken(RELOP);
{token_binop}     newToken(BINOP);
{token_comment}   token_value = "\/\/"; return COMMENT;
{token_id}        newToken(ID);
{token_num}       newToken(NUM);

\"                BEGIN(STR);newString("");
<STR>\"           BEGIN(INITIAL);return (STRING);
<STR>{printable_str}   appendString(0);
<STR>\\           BEGIN(STR_ES);

<STR_ES>{escape_1}   str_es(Backslash);BEGIN(STR);
<STR_ES>{escape_2}   str_es(QuotationMark);BEGIN(STR);
<STR_ES>{escape_3}   str_es(LF);BEGIN(STR);
<STR_ES>{escape_4}   str_es(CR);BEGIN(STR);
<STR_ES>{escape_5}   str_es(TAB);BEGIN(STR);
<STR_ES>{escape_6}   str_es(NUL);BEGIN(STR);

<STR_ES>x               BEGIN(STR_HEX);
<STR_HEX>{escape_hexa}  str_es(HEXA);BEGIN(STR);
<STR_HEX>.              str_es(InvalidHexa);

<STR_ES>.          str_es(InvalidES);

<STR>{newLine}   printf("Error unclosed string\n");exit(0);
<STR>.   printf("Error %c\n", yytext);exit(0);

{whitespace}                ;
.		printf("Lex doesn't know what that is!\n");

%%

void showToken(char* token_name){
    printf("%d %s %s \n", yylineno, token_name, yytext);
    //cout << yylineno << " " << token_name << " " << yytext << endl;
    
}

void newString(char* token_name){
    token_value = "";
}

char to_hex(){
    string tmp(yytext);
    //cout << "to_hex:: yytext: " << yytext << " tmp:" << tmp << " to: " << stoi(tmp, 0, 16) << " is: " << char(stoi(tmp, 0, 16)) << endl; 
    return stoi(tmp, 0, 16);
}


void str_es(int escapeSequence_type){
    switch (escapeSequence_type){
        case Backslash:
            token_value.push_back('\\');
            break;
        case QuotationMark:
            token_value.push_back('\"');
            break;
        case LF:
            token_value.push_back('\n');
            break;
        case CR:
            token_value.push_back('\r');
            break;
        case TAB:
            token_value.push_back('\t');
            break;
        case NUL:
            token_value.push_back('\0');
            break;
        case HEXA:
            token_value.push_back(to_hex());
            break;
        case InvalidHexa:
            printf("Error undefined escape sequence %c%c%c\n", yytext);
            exit(0);
        default:
            printf("Error undefined escape sequence %c\n", yytext);
            exit(0);
    };
    //cout << "str_es[" << token_value.size() << "]:: " << token_value.c_str() << endl;
}

void appendString(int token_name){
    string tmp(yytext);
    token_value.append(tmp);
}


void printString(char* token_name){
    printf("%s \n", token_value.c_str());
    //cout << token_value << endl;
}


/*
<STR_NICE>{legal_escape}      showToken("legal_escape:: ");
<STR_NICE>{printable_str}   showToken("");
<STR_NICE>\\      printf("Log::ILLIGAL \\");
<STR_NICE>.       showToken("Log::Unknown string");

*/