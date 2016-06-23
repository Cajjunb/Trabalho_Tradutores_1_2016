/* Verificando a sintaxe de programas segundo nossa GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include "tabela.c"
#include "globals.h"
#include "code.h"

/*Variaveis globais Nossas*/
int  comandosCondicionais = 1;

%}


%union {
	char *cadeia;
	int  val;
}

%token INICIO
%token FIM
%token WHILE
%token  NUMERO
%token  SE
%token  OU
%token FIMSE
%token IDENTIFICADOR
%token ATRIB
%token REL
%token OP
%left OP
%token INT
%token VOID
%token OUTPUT
%token INPUT


%type<cadeia> IDENTIFICADOR 
%type<val> NUMERO 

%%
/* Regras definindo a GLC e acoes correspondentes */
/* neste nosso exemplo quase todas as acoes estao vazias */

programa:	 declarationList INICIO statementlist FIM 			{printf("\tFIM do parser\n");}
;

declarationList: declarationList declaration | declaration 		{	
																	printf("\tDeclarationList\n");
																}
;

declaration: typeSpecifier IDENTIFICADOR ';' 					{	
																	emitRM("LD",mp,6,ac,"load maxaddress from location 0");
																	printf("\tDeclaracao de IDENTIFICADOR - %s\n",$2);
																	atualizaTabela( &tabeladeSimbolos, $2, 'd', "int");}
;

typeSpecifier: INT | VOID 										{
																	printf("\ttipo\n");
																}
;

statementlist:  statement										{
																	printf("\tstatement\n");
																}
		| statementlist ';' statement							{
																	printf("\tstatementlist\n");
																}
;

iterationStatement: WHILE '(' expression ')' statement 'fimWhile'			{;}

;

statement:		IDENTIFICADOR ATRIB expression					{	
																	printf("\tUtilizacao de IDENTIFICADOR %s\n", $1);
																	if(!atualizaUso(&tabeladeSimbolos, $1)){
																		erroSemantico++;
																		printf("\tERRO: %s nao foi declarado\n",$1);
																	}
																}
				| imprime										{
																	printf("\tIMPRIME\n");
																}
				| selectionStatement							{
																	printf("\t SELECTION STATEMENT\n");
																}
				| iterationStatement 							{
																	printf("\titeration!\n");
																}
				| leitura										{
																	;
																}
;


selectionStatement:  SE '(' expression ')' conditionalStatement {
																	printf("\t Condicional SE \n"); printf("\tNumero de Linhas = %d\n",comandosCondicionais);
																}
					| SE '(' expression ')' conditionalStatement OU conditionalStatement 
																{
																	printf("\t Condicional SE e SENAO \n");
																} 
;

conditionalStatement: statement									{
																	printf("\tConditional Statement\n");
																}
;


imprime:	OUTPUT expression 											{emitRO("OUT",ac,0,0,"write ac"); comandosCondicionais++ ; printf("\tNumero de Linhas = %d\n",comandosCondicionais);} 

;

leitura:	INPUT identificador 										{emitRO("IN",ac,0,0,"write ac");comandosCondicionais++; printf("\tNumero de Linhas = %d\n",comandosCondicionais);}

;


expression:	expression REL aritexpression    					{
																	printf("\texpressionRELatritexpression\n");
																}
		| aritexpression										{
																	printf("\tatritexpression\n");
																}
;

aritexpression:     NUMERO 										{
																	printf("\tNumero = %d \n",$1);
																	emitRM("LDC",ac, $1,0,"load const");
																	comandosCondicionais++;
																	printf("\tNumero!\n");
																}
        | identificador 													{
        																		;
        																	}
        | aritexpression OP aritexpression 						{
        															printf("\tatrib expr atrib\n");
        														}
;


identificador: IDENTIFICADOR 									{
																	printf("\tUtilizacao de IDENTIFICADOR - %s\n",$1);
																	if(!atualizaUso(&tabeladeSimbolos, $1)){
																		erroSemantico++;printf("\tERRO: %s nao foi declarado\n",$1);
																	};
																}


%%
extern FILE *yyin;

/* allocate global variables */
int lineno = 0;
FILE * source;
FILE * listing;
FILE * code;

/* allocate and set tracing flags */
int EchoSource = FALSE;
int TraceScan = FALSE;
int TraceParse = FALSE;
int TraceAnalyze = FALSE;
int TraceCode = FALSE;

int Error = FALSE;
int main (int argc, char*argv[]) {
	int erroSintatico;


	printf("\tLendo o arquivo %s\n", argv[1]);
	yyin  = fopen(argv[1], "r");
	yyout = fopen(strcat(argv[1], ".tm"), "w");

	if(yyin){
		//emitComment("Standard prelude:");
		emitRM("LD",mp,0,ac,"load maxaddress from location 0");
		emitRM("ST",ac,0,ac,"clear location 0");
		//emitComment("End of standard prelude.");

		//emitComment("End of execution.");
		

		erroSintatico = yyparse ();
		emitRO("HALT",0,0,0,"");

		if(erroSintatico == 0)
			printf("\tPrograma sintaticamente correto!\n");
		else
			yyerror(erroSintatico);
		//Verificiando se algum simbolo nao foi usado
		verificaNaoUsado(&tabeladeSimbolos);

	}
	else
		printf("\terro na leitura do arquivo %s\n", argv[1]);

	return 0;
}

yyerror (s){
	fprintf (stderr, "\tERRO = %s\n", s);
}

