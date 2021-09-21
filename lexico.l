%{

#include <string.h>
#include <float.h>
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include "ts.h"

FILE  *yyin;

/* FUNCIONES */

char* normalizar(char*);
int validarID(char *str);
int longitud(char *str);

%}

%option noyywrap 
%option yylineno

DIGITO					[0-9]
LETRA					[a-zA-Z]
COMA                    ","
PUNTO                   "."
CONST_STR               \"({LETRA}|{DIGITO}|.)+\"
COMENTARIOS             (\*\/).*(\/\*)
CONST_REAL              {DIGITO}+{PUNTO}{DIGITO}+
CONST_INT               {DIGITO}+
ID						{LETRA}({LETRA}|{DIGITO})*
OP_ASIG   				":="
ASIG_ESP				(\+=)|(\-=)|(\*=)|(\/=)
C_A                     "["
C_C                     "]"
ESPACIO					" "

%%
"lista"|"LISTA"			{ return LISTA; }
"longitud"|"LONGITUD"	{ yylval.strval = strdup(yytext);
						  longitud(yylval.strval);
						  return LONGITUD;
						}
"defvar"|"DEFVAR"		{ return DEFVAR; }
"dim"|"DIM"				{ return DIM; }
"as"|"AS"				{ return AS; }
"int"|"INT"				{ return INT; }
"real"|"REAL"			{ return REAL; }
"enddef"|"ENDDEF"		{ return ENDDEF; }
"string"|"STRING"		{ return STRING; }
"display"|"DISPLAY"		{ return DISPLAY; }
"get"|"GET"				{ return GET; }
"while"|"WHILE"			{ return WHILE; }
"if"|"IF"				{ return IF; }
"else"|"ELSE"			{ return ELSE; }
"real|REAL"				{ return REAL; }
{CONST_INT}				{ 
							strcpy(yylval.strval, yytext);
							int casteado = atoi(yytext);
							if( casteado > 65536) {
								
								printf("ERROR Lexico - Entero \'%d\' fuera de rango. Debe estar entre [0; 65536]", casteado);
								return 0;
						}
							insertInTs(normalizar(yytext), "CONST_INT", yytext, "");
							return CONST_INT;
						}
{CONST_REAL}			{ 	
							strcpy(yylval.strval, yytext);
							double casteado = atof(yytext);
							if(casteado > FLT_MAX) {
								
								printf("ERROR Lexico - Float \'%f\' fuera de rango. Debe estar entre [0; %e]", casteado, FLT_MAX);
								return 0;
							}
							insertInTs(normalizar(yytext), "CONST_REAL", yytext, "");
							return CONST_REAL;
						}
{CONST_STR}				{	strcpy(yylval.strval, yytext);
							int longitud = strlen(yytext);
							//en lugar de 30 verifica con 32 porque el string viene entre comillas
							if(longitud > 32){
								char msg[150];
								printf("ERROR Lexico - Cadena \'%s\' demasiado larga. Maximo de 30 caracteres y contiene: %d", yytext, longitud-2);
								return 0;
							}
							char stringLength[20];
							sprintf(stringLength, "%d", longitud);
							insertInTs(normalizar(yytext), "CONST_STR", yytext, stringLength);
							return CONST_STR;	
						}
">"                     { return CMP_MAY;}
">="                    { return CMP_MAYI;}
"<"                     { return CMP_MEN;}
"<="                    { return CMP_MENI;}
"!="                    { return CMP_DIST;}
"=="                    { return CMP_IGUAL;}
":="					{ return OP_ASIG;}
"+"						{ return OP_SUM;}
"-"						{ return OP_RES;}
"*"						{ return OP_MUL;}
"/"						{ return OP_DIV;}
"("						{ return P_A;}
")"						{ return P_C;}
"["						{ return C_A;}
"]"						{ return C_C;}
"{"						{ return L_A;}
"}"						{ return L_C;}
";"						{ return PUNTO_Y_COMA;}
":"						{ return DOSPUNTOS;}
","						{ return COMA;}
"."						{ return PUNTO;}
"="						{ return OP_IGUAL;}
"and"|"AND"				{ return AND;}
"or"|"OR"				{ return OR;}
"not"|"NOT"				{ return NOT;}
{COMENTARIOS} 			{ ;} 
{ID}					{ 	yylval.strval = strdup(yytext);
							validarID(yylval.strval);
							insertInTs(yytext, "", "", "");
							return ID;
						}
{ASIG_ESP}				{ return ASIG_ESP;}
\n\r
\n
\t
{ESPACIO}
" "						

%%
char* normalizar(char* cadena){
	char *aux = (char *) malloc( sizeof(char) * (strlen(cadena)) + 2);
	strcpy(aux,"_");
	strcat(aux,cadena);
	return aux;
}

int validarID(char *str)
{
    int largo = strlen(str);
 
	if(largo > 10){
		printf("(!) ERROR: Identificador fuera de rango (10 caracteres maximo) -> Linea %d\n", yylineno);
		fprintf(stderr, "Fin de ejecucion.\n");
		system ("Pause");
		exit (1);
	}else{
		//printf(" Valide bien el identificador! : %s\n", str);
	}
	
	return 1;
}

int longitud(char *str)
{
	int largo = 0;
	char *aux = str;
	aux++;
	int ban = 0;
	while(*aux != ']')
	{
		ban = 1;
		if(*aux == ',')
			largo++;
		aux++;
	}
	
	if(largo > 0 || ban == 0)
		largo++;
	
	printf("%d", largo);
}