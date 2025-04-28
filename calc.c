#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "parser.h"

struct variables {
    char nombre[50];
    double valor;
};

struct variables variable[100];

void cargar_variables (int pos, char *nom, double val) {
	strcpy(variable[pos].nombre,nom);
		variable[pos].valor=val;
}
int buscar_variable (char *buscar, int cant) {
	for (int x=0;x<=cant;x++) {
		if (strcmp(variable[x].nombre,buscar) == 0) { // si coinciden
			return 0;
			break;
		}
	}
	return -1;
}
double asignar_val (char *nom, double val, int cant) {
	int x;
	for (x=0;x<=cant;x++) {
		if (strcmp(variable[x].nombre,nom) == 0) { // si coinciden
			variable[x].valor=val;
			break;
		}
	}
	return variable[x].valor;
}


double buscar_valor (char *buscar, int cant) {
	double val;
	for (int x=0;x<=cant;x++) {
		if (strcmp(variable[x].nombre,buscar) == 0) { // si coinciden
			val = variable[x].valor;
			return val;
			break;
		}
	}
	return -99999;
}