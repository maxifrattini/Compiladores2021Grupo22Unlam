%{
#include <stdio.h>
#include <stdlib.h>
#include "ts.h"

FILE  *yyin;
extern int yylineno;
int yylex();
int yyerror();
%}

%union{
	  char *strval;
	  char a_e[2];
}

%token <a_e> ASIG_ESP
%token DEFVAR DIM AS ENDDEF
%token REAL INT STRING
%token CONST_REAL CONST_INT CONST_STR
%token LISTA LONGITUD
%token DISPLAY GET
%token IF ELSE WHILE         
%token P_A P_C C_A C_C L_A L_C PUNTO PUNTO_Y_COMA COMA DOSPUNTOS
%token CMP_MAY CMP_MEN CMP_MAYI CMP_MENI CMP_DIST CMP_IGUAL
%token OP_SUM OP_RES OP_DIV OP_MUL
%token AND OR NOT
%type <strval> expresion
%token <strval> ID
%token OP_ASIG
%token OP_IGUAL

%%

programa: program {printf("\nprogram - program\nCompilacion exitosa\n");};
program:
	sentencia 				{printf("\nprogram - sentencia");}
	| program sentencia 	{printf("\nprogram - program sentencia");}
	;
	
sentencia:DEFVAR declaraciones ENDDEF{printf("\nsentencia - DEFVAR declaraciones ENDDEF");}
			| ID ASIG_ESP factor {printf("\nSentencia - ID ASIG_ESP factor");}
			| funcion {printf("\nsentencia - funcion");}
            | asignacion PUNTO_Y_COMA { printf("\nsentencia - asignacion");}
            | decision              {   printf("\nsentencia - decision");}
            | iteracion             { printf("\nsentencia - iteracion");}
            | entrada               {printf("\nsentencia - entrada");}
            | salida                {printf("\nsentencia - salida");}
	        ;

funcion: LONGITUD P_A C_A lista_ids C_C P_C{
													printf("\nsentencia - LONGITUD P_A C_A lista_ids C_C P_C");
												};

declaraciones:         	        	
             declaracion					{ printf("\ndeclaraciones - declaracion");}
             | declaraciones declaracion	{printf("\ndeclaraciones - declaraciones declaracion");}
    	     ;

declaracion:  DIM C_A lista_ids C_C AS C_A lista_tipo_datos C_C{  
                                        printf("\ndeclaracion - DIM C_A lista_ids C_C AS C_A lista_tipo_datos C_C");
                                    }
			;

lista_ids: ID { printf("\nlista_ids - ID '%s'",yylval.strval);}
			| lista_ids COMA ID {printf("\nlista_ids - lista_ids COMA ID '%s'",yylval.strval);}
			;
			
tipo_dato: INT 			{	
							printf("\n tipo de dato : INT");
						}
	| REAL			{	
							printf("\n tipo de dato : REAL");
						}
	| STRING		{	
							printf("\n tipo de dato : STRING");
						}
	;

lista_tipo_datos: tipo_dato {
									printf("\n lista tipo dato : dato");
								}
	| lista_tipo_datos COMA tipo_dato {
											printf("\n lista tipo dato : lista_datos");
										}
	;
entrada:
    DISPLAY ID  PUNTO_Y_COMA        {printf("\nentrada DISPLAY - ID"); }
    | DISPLAY constanteString PUNTO_Y_COMA {printf("\nentrada DISPLAY - CONST_STR"); }
    ;
	
asignacion:
    ID OP_ASIG expresion { printf("\nasignacion ID - OP_ASIG - expresion");}
    | ID OP_ASIG constanteString { printf("\nasignacion ID - OP_ASIG - CTE_STRING");}
;
    
salida:
    GET ID  PUNTO_Y_COMA {printf("\nsalida GET - ID"); }
    ;

iteracion:
     WHILE P_A condicion P_C L_A sentencia L_C { printf("\niteracion - WHILE P_A condicion P_C L_A sentencia L_C");}
    ;

decision: 
    IF P_A condicion P_C L_A sentencia L_C {   printf("\ndecision - IF P_A condicion P_C L_A sentencia L_C");
 
                                                 }
   | IF P_A condicion P_C L_A sentencia L_C {  printf("\ndecision - IF P_A condicion P_C L_A sentencia L_C");
                                                
                                               
                                                 }
    ELSE                                    {   printf("\nInicio del else");
                                                   }
    L_A sentencia L_C                      {   printf("\nFin del else");
                                                
                                            
                                                }
 
   ;

condicion: 
    expresion CMP_MAY expresion     {   printf("\ncondicion - expresion CMP_MAY expresion");
                                        
                                         }
    | expresion CMP_MEN expresion   {   printf("\ncondicion - expresion CMP_MEN expresion");
                                        
                                          }
    | expresion CMP_MAYI expresion   {  printf("\ncondicion - expresion CMP_MAYI expresion");
                                        
                                          }
    | expresion CMP_MENI expresion  {   printf("\ncondicion - expresion CMP_MENI expresion");
                                        
                                         }
    | expresion CMP_DIST expresion  {   printf("\ncondicion - expresion CMP_DIST expresion");
                                        
                                        }
    | expresion CMP_IGUAL expresion {   printf("\ncondicion - expresion CMP_IGUAL expresion");
                                        
                                           }


    | P_A condicion P_C AND P_A condicion P_C   {   printf("\ncondicion - AND");

    }

    | P_A condicion P_C OR P_A condicion P_C    {   printf("\ncondicion - OR"); 
    }

    
    |NOT expresion CMP_MAY expresion     {   printf("\ncondicion - NOT expresion CMP_MAY expresion");
                                        
                                         }
    |NOT expresion CMP_MEN expresion   {   printf("\ncondicion - NOT expresion CMP_MEN expresion");
                                        
                                          }
    |NOT expresion CMP_MAYI expresion   {  printf("\ncondicion - NOT expresion CMP_MAYI expresion");
                                        
                                          }
    |NOT expresion CMP_MENI expresion  {   printf("\ncondicion - NOT expresion CMP_MENI expresion");
                                        
                                          }
    |NOT expresion CMP_DIST expresion  {   printf("\ncondicion - NOT expresion CMP_DIST expresion");
                                        
                                        }
    |NOT expresion CMP_IGUAL expresion {   printf("\ncondicion - NOT expresion CMP_IGUAL expresion");
                                        
                                        }
    ;


    
expresion:
    expresion OP_SUM termino        {   printf("\nexpresion - expresion OP_SUM termino"); 
                                        
                                         }
    | expresion OP_RES termino      {   printf("\nexpresion - expresion OP_RES termino");
                                         }
    | termino                       {   printf("\nexpresion - termino");   }
    ;

termino: 
    termino OP_MUL factor       {   printf("\ntermino - termino OP_MUL factor"); 
                                    
                                   
                                    }
    | termino OP_DIV factor     {   printf("\ntermino - termino OP_DIV factor"); 
                                    
                                   
                                   }
    | factor                    {   printf("\ntermino - factor");
                                       }
    ;

factor: 
    P_A expresion P_C           {   printf("\nfactor - P_A expresion P_C");
                                    }
    | ID                        {   printf("\nfactor - ID ");
                                    
                                    }
    | constanteNumerica         {   printf("\nfactor - constanteNumerica");
                                     }  
    ;

constanteNumerica: 
    CONST_INT               {   
                            printf("\nconstante - ENTERO: %s", yylval.strval);
                            
                            }
    | CONST_REAL            {   
                            printf("\nconstante - REAL: %s" , yylval.strval);
                                                       
                            };

constanteString: 
    CONST_STR        {  
                            printf("\nconstante - STRING %s" , yylval.strval);
                        }
    ;

%%

int main(int argc,char *argv[])
{
	if ((yyin = fopen(argv[1], "rt")) == NULL)
	{
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
	}
	else
	{
			yyparse();
	}
	fclose(yyin);
	return 0;
}
int yyerror(void)
{
	printf("Syntax Error en la linea: %d\n", yylineno);
	system ("Pause");
	exit (1);
}