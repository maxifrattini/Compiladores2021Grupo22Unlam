%{

#include <string.h>
#include <float.h>
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

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
CONST_STR               \"({LETRA}|{DIGITO}|.)*\"
COMENTARIOS             (\*\/).*(\/\*)
CONST_REAL              {DIGITO}+{PUNTO}{DIGITO}+
CONST_INT               {DIGITO}+
ID						{LETRA}({LETRA}|{DIGITO})*
OP_ASIG   				":="
C_A                     "["
C_C                     "]"

%%
"defvar"|"DEFVAR"		{ return DEFVAR; }
"dim"|"DIM"				{ return DIM; }
"as"|"AS"				{ return AS; }
"int"|"INT"				{ return INT; }
"real"|"REAL"			{ return REAL; }
"string"|"STRING"		{ return STRING; }
"enddef"|"ENDDEF"		{ return ENDDEF; }
"display"|"DISPLAY"		{ return DISPLAY; }
"get"|"GET"				{ return GET; }
"while"|"WHILE"			{ return WHILE; }
"if"|"IF"				{ return IF; }
"else"|"ELSE"			{ return ELSE; }
"longitud"|"LONGITUD"	{ 
							longitud(yylval.strval);
							return LONGITUD;
						}
{CONST_INT}				{ 
							strcpy(yylval.strval, yytext);
							int casteado = atoi(yytext);
							if( casteado > 65536) {
								
								printf("ERROR Lexico - Entero \'%d\' fuera de rango. Debe estar entre [0; 65536]", casteado);
								return 0;
							}
							return CONST_INT;
						}
{CONST_REAL}			{ 	
							strcpy(yylval.strval, yytext);
							double casteado = atof(yytext);
							if(casteado > FLT_MAX) {
								
								printf("ERROR Lexico - Float \'%f\' fuera de rango. Debe estar entre [0; %e]", casteado, FLT_MAX);
								return 0;
							}
							return CONST_REAL;
						}
{CONST_STR}				{	strcpy(yylval.strval, yytext);
							int longitud = strlen(yytext);
							//en lugar de 30 verifica con 32 porque el string viene entre comillas
							if(longitud > 32){
								printf("\nERROR Lexico - Cadena \'%s\' demasiado larga. Maximo de 30 caracteres y contiene: %d", yytext, longitud-2);
								return 0;
							}
							char stringLength[20];
							
							sprintf(stringLength, "%d", longitud);
							
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
{ID}					{
							yylval.strval = strdup(yytext);
							
							validarID(yylval.strval);
							return ID;
						}
\n\r
\n
\t
" "						

%%
int validarID(char *str)
{
    int largo = strlen(str);
 
	if(largo > 10){
		printf("(!) ERROR: Identificador fuera de rango (10 caracteres maximo) -> Linea %d\n", yylineno);
		
		fprintf(stderr, "Fin ejecucion.\n");
		
		system ("Pause");
		
		exit (1);
	}
	
	return 1;
}

int longitud(char *str)
{
	int largo = 0;
	char *aux = str;
	aux++;
	int ban = 0;

	while(*aux && *aux != ']')
	{
		ban = 1;
		if((*aux) == ','){
			largo++;
		}
		aux++;
	}
	
	if(largo > 0 || ban == 1){
		largo++;
	}
	
	printf("\nlongitud = %d", largo);
}