%option noyywrap

%{
#include <stdio.h>
#include <strings.h>
#include "parser.h"
%}

%{
	int errlex;
	char msg[120];
%}

%option header-file="scanner.h"
%option outfile="scanner.c"
%option noinput
%option nounput

Letra														[[:alpha:]]
Digito														[0-9]
Letra_Digito												[[:alnum:]]
Otros														[@!:;'¨_|#?¿¡]
E															e
PI															pi
SIN               											sin
COS               											cos
TAN               											tan
SQRT               											sqrt
LOG               											log
VAR               											var
OPERADORES_MATEMATICOS										"+"|"-"|"*"|"/"|"^"
IGUAL														=
MAS_IGUAL               									"+="
MENOS_IGUAL													"-="
POR_IGUAL													"*="
DIVISION_IGUAL												"/="
CARACTER_PUNTUACION     									"("|")"
FIN_PROGRAMA            									salir

%%
{FIN_PROGRAMA}												{yylval.tipo_txt = strdup(yytext); return FDT;}
{VAR}														{yylval.tipo_txt = strdup(yytext); return TKN_VAR;}
{E}															{yylval.tipo_txt = strdup(yytext); return E; }
{PI}														{yylval.tipo_txt = strdup(yytext); return PI; }
{COS}														{yylval.tipo_txt = strdup(yytext); return FUN_COS; }
{TAN}														{yylval.tipo_txt = strdup(yytext); return FUN_TAN; }
{SIN}														{yylval.tipo_txt = strdup(yytext); return FUN_SEN; }
{SQRT}														{yylval.tipo_txt = strdup(yytext); return FUN_RAIZ; }
{LOG}														{yylval.tipo_txt = strdup(yytext); return FUN_LOG; }
{Letra}{Letra_Digito}*										{yylval.tipo_txt = strdup(yytext); return IDENTIFICADOR; }
{Digito}+													{yylval.tipo_double = atof(yytext); return NUMERO; }
{Digito}+"."{Digito}+										{yylval.tipo_double = atof(yytext); return NUMERO; }
{CARACTER_PUNTUACION}										{yylval.tipo_caract = yytext[0]; return yytext[0];}
{OPERADORES_MATEMATICOS}									{yylval.tipo_caract = yytext[0]; return yytext[0];}
{IGUAL}														{yylval.tipo_caract = yytext[0]; return yytext[0];}
{MAS_IGUAL}													{yylval.tipo_txt = strdup(yytext); return MAS_IGUAL; }
{MENOS_IGUAL}												{yylval.tipo_txt = strdup(yytext); return MENOS_IGUAL; }
{POR_IGUAL}													{yylval.tipo_txt = strdup(yytext); return POR_IGUAL; }
{DIVISION_IGUAL}											{yylval.tipo_txt = strdup(yytext); return DIVISION_IGUAL; }
\n                              							{yylval.tipo_txt = strdup(yytext); return NL; }
{Otros}+													{ sprintf(msg,"Error léxico: cadena desconocida: %s", yytext); yyerror(msg);}
{Letra}{Letra_Digito}*{Otros}+.*							{ sprintf(msg, "Error léxico: identificador inválido: %s", yytext); yyerror(msg);}
{Digito}+{Letra}+{Letra_Digito}*							{ sprintf(msg, "Error léxico: constante inválida: %s", yytext); yyerror(msg);}
{Digito}+".".*												{ sprintf(msg, "Error léxico REAL inválido: %s", yytext); yyerror(msg);}
. 															{}
%%