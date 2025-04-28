#include <stdio.h>
#include "parser.h"

void yyerror(const char *s){
	printf(">%s\n", s);
	return;
}

int main() {
	yyparse();
	return 0;
}