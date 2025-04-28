%{
#include <stdio.h>
#include "scanner.h"
#include <math.h>
#include "calc.h"

int cont_var=0;
%}

%code requires {
void yyerror(const char *s);
}

%defines "parser.h"
%output "parser.c"
%define parse.error verbose

%union {
    double tipo_double;
    char tipo_caract;
    char* tipo_txt;
}


%token <tipo_double> NUMERO E PI 
%token <tipo_txt> IDENTIFICADOR
%right <tipo_txt> MAS_IGUAL MENOS_IGUAL POR_IGUAL DIVISION_IGUAL
%right <tipo_txt> FUN_COS FUN_LOG FUN_RAIZ FUN_SEN FUN_TAN
%token SALIR
%right '='
%left '+' '-'
%left '*' '/'
%right '^'
%precedence NEG
%token FDT TKN_VAR NL

%type <tipo_double> expresion definicion asignacion valor operacion



%%
inicio: 				programa FDT 								{printf(">"); return 0;}
					| 	FDT 										{printf(">"); return 0;}
					;
programa: 				programa calculadora
					| 	calculadora
					;
calculadora: 			definicion NL 								{printf("\n");}
					| 	expresion NL 								{printf(">%lf\n",$1);}
					| 	error NL 									
					|	error asignacion asignacion 				{printf(">Los operadores de asignación solo admiten una variable como operando izquierdo.\n");
																	yyerrok; }
					| 	NL
					;

definicion : 			TKN_VAR IDENTIFICADOR						{	int r = buscar_variable($2,cont_var);
																	if (r==0) {
																		printf(">Error. Identificador %s ya declarado como variable\n",$2);
																		YYERROR;
																	}else {
																		cargar_variables(cont_var,$2,0);
																		cont_var++;
																		printf(">%s: 0",$2);
																		}
																	}

					| 	TKN_VAR IDENTIFICADOR '=' expresion			{	int r = buscar_variable($2,cont_var);
																	if (r==0) {
																		printf(">Error. Identificador %s ya declarado como variable\n",$2);
																		YYERROR;
																	}else {
																		cargar_variables(cont_var,$2,$4);
																		cont_var++;
																		printf("> %s: %lf", $2, $4);
																		}
																	} 
					;

valor :					IDENTIFICADOR								{	int r = buscar_variable($1,cont_var);
																		if (r==0) {
																			$$ = buscar_valor($1,cont_var);
																		}else {
																				printf(">Error. Identificador %s no declarado\n",$1);
																				YYERROR;
																			}
																	}
					|   NUMERO										{$$ = $1;}
					|	E											{$$ = 2.7182818285;}
					|   PI											{$$ = 3.1415926536;}
					;

expresion: 				valor
					|	asignacion
					| 	operacion
					| 	'(' expresion ')' 							{ $$ = $2; }

asignacion :			IDENTIFICADOR '=' expresion					{	int r = buscar_variable($1,cont_var);
																		if (r==0) {
																			asignar_val($1,$3,cont_var);
																			$$ = $3;
																		}else {
																			printf(">Error. Identificador %s no declarado\n",$1);
																			YYERROR;
																		}
																	}
																	
					|	IDENTIFICADOR MAS_IGUAL expresion			{	int r = buscar_variable($1,cont_var);
																		if (r==0) {
																			double nuevo_valor = buscar_valor($1,cont_var) + $3;
																			asignar_val($1,nuevo_valor,cont_var);
																			$$ = nuevo_valor;
																		}else {
																			printf(">Error. Identificador %s no declarado\n",$1);
																			YYERROR;
																		}
																	}
					|	IDENTIFICADOR MENOS_IGUAL expresion			{	int r = buscar_variable($1,cont_var);
																		if (r==0) {
																			double nuevo_valor = buscar_valor($1,cont_var) - $3;
																			asignar_val($1,nuevo_valor,cont_var);
																			$$ = nuevo_valor;
																		}else {
																			printf(">Error. Identificador %s no declarado\n",$1);
																			YYERROR;
																		}
																	}
					|	IDENTIFICADOR POR_IGUAL expresion			{	int r = buscar_variable($1,cont_var);
																		if (r==0) {
																			double nuevo_valor = buscar_valor($1,cont_var) * $3;
																			asignar_val($1,nuevo_valor,cont_var);
																			$$ = nuevo_valor;
																		}else {
																			printf(">Error. Identificador %s no declarado\n",$1);
																			YYERROR;
																		}
																	}
                    |	IDENTIFICADOR DIVISION_IGUAL expresion		{	if ($3==0) {
																			printf(">Error. La división por 0 no existe\n");
																			YYERROR;
																		}else {
																			int r = buscar_variable($1,cont_var);
																			if (r==0) {
																				double nuevo_valor = buscar_valor($1,cont_var) / $3;
																				asignar_val($1,nuevo_valor,cont_var);
																				$$ = nuevo_valor;
																			}else {
																				printf(">Error. Identificador %s no declarado\n",$1);
																				YYERROR;
																			}
																		}
																	}
					;

operacion:			 	'-'valor %prec NEG							{$$ = -$2;}
                    | 	expresion '+' expresion 					{$$ = $1 + $3;}
                  	| 	expresion '-' expresion 					{$$ = $1 - $3;}
                   	| 	expresion '*' expresion 					{$$ = $1 * $3;}
                  	| 	expresion '/' expresion 					{ if($3 == 0){
																		printf("ZError matemático. La división por 0 no existe");
																		YYERROR;
																		}else{
																			$$= $1 / $3; 
																		}
																	}
					|	expresion '^' expresion						{$$ = pow($1,$3);}
					|	FUN_COS'('expresion')'						{$$ = cos($3);}
					|	FUN_TAN'('expresion')'						{$$ = tan($3);}
					|	FUN_SEN'('expresion')'						{$$ = sin($3);}
					|	FUN_RAIZ'('expresion')'						{$$ = sqrt($3);}
					|	FUN_LOG'('expresion')'						{$$ = log($3);}
					;
