/* Verificando a sintaxe de programas segundo nossa GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
#include <stdio.h> 
#include <string.h> 
#include "tabela.c"
#include "globals.h"
#include "code.h"

%}

%union {
char *cadeia;
int val;
}

%token INICIO
%token FIM
%token WHILE
%token NUMERO
%token IDENTIFICADOR
%token ATRIB
%token REL
%token OP
%left OP
%token INT
%token VOID
%token OUTPUT


%type<cadeia> IDENTIFICADOR 
%type<val> NUMERO 

%%
/* Regras definindo a GLC e acoes correspondentes */
/* neste nosso exemplo quase todas as acoes estao vazias */

programa:	 declarationList INICIO statementlist FIM 			{;}
;

declarationList: declarationList declaration | declaration 		{/*debug*//*printf("DeclarationList\n")*/;}
;

declaration: typeSpecifier IDENTIFICADOR ';' 								{/*debug*//*printf("Declaracao de IDENTIFICADOR - %s\n",$2)*/;atualizaTabela( &tabeladeSimbolos, $2, 'd', "int");}
;

typeSpecifier: INT | VOID 										{/*debug*//*printf("tipo\n")*/;}
;

statementlist:  statement										{/*debug*//*printf("statement\n")*/;}
		| iterationStatement ';'								{/*debug*//*printf("iteration!\n")*/;}
		| statementlist ';' statement							{/*debug*//*printf("statementlist\n")*/;}
;

iterationStatement: WHILE '(' expression ')' statement 			{;}

;

statement:		IDENTIFICADOR ATRIB expression								{/*debug*//*printf("Utilizacao de IDENTIFICADOR %s\n", $1)*/;if(!atualizaUso(&tabeladeSimbolos, $1)){erroSemantico++;printf("\tERRO: %s nao foi declarado\n",$1);}}
				| imprime										{;}
;

imprime:	OUTPUT expression 											{emitRO("OUT",ac,0,0,"write ac");}

;

expression:	expression REL aritexpression    					{/*debug*//*printf("expressionRELatritexpression")*/;}
		| aritexpression										{/*debug*//*printf("atritexpression\n")*/;}
;

aritexpression:     NUMERO 										{emitRM("LDC",ac,$0,0,"load const");/*debug*//*printf("Numero!\n")*/;}
        | IDENTIFICADOR 													{/*debug*//*printf("Utilizacao de IDENTIFICADOR - %s\n",$1)*/;if(!atualizaUso(&tabeladeSimbolos, $1)){erroSemantico++;printf("\tERRO: %s nao foi declarado\n",$1);}}
        | aritexpression OP aritexpression 						{/*debug*//*printf("atrib expr atrib\n")*/;}
;

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
		//Verificiando se algum simbolo nao foi usado
		verificaNaoUsado(&tabeladeSimbolos);

	}
	else
		printf("\terro na leitura do arquivo %s\n", argv[1]);

	return 0;
}

yyerror (s){
	fprintf (stderr, "\t%s\n", s);
}

