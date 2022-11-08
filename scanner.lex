%{

/* Declarations section */
#include <stdio.h>
#include "tokens.hpp"

void showToken(char* token_name);
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

good_escape_sequence    (\\\\ | \\" | \\n | \\r | \\t | \\0 | \\x[0-9][0-9])

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
escape_2        (\\")
escape_3        (\\n)
escape_4        (\\r)
escape_5        (\\t)
escape_6        (\\0)
escape_7        (\\x{hexa}{hexa})
legal_escape    (escape_1|escape_2|escape_3|escape_4|escape_5|escape_6|escape_7)

token_string    ()

%x STR_NICE
%x INTIAL

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
\"                 BEGIN(STR_NICE);
<STR_NICE>[{printable}{-}\\]*   showToken("string_part");
<STR_NICE>\"        BEGIN(INTIAL);
{whitespace}				;
.		printf("Lex doesn't know what that is!\n");

%%

void showToken(char* token_name){
    printf("%d %s %s\n", yylineno, token_name, yytext);
    //cout << yylineno << " " << token_name << yytext << endl;
    
}




