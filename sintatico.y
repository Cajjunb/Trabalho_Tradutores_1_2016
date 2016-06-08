/* Verificando a sintaxe de programas segundo nossa GLC-exemplo */
/* considerando notacao polonesa para expressoes */
%{
#include <stdio.h> 
#include "tabela.c"
%}

%union {
char *cadeia;
}

%token INICIO
%token FIM
%token WHILE
%token NUM
%token ID
%token ATRIB
%token REL
%token OP
%left OP
%token INT
%token VOID
%token OUTPUT


%type<cadeia> ID 

%%
/* Regras definindo a GLC e acoes correspondentes */
/* neste nosso exemplo quase todas as acoes estao vazias */

programa:	 declarationList INICIO statementlist FIM 			{;}
;

declarationList: declarationList declaration | declaration 		{/*debug*//*printf("DeclarationList\n")*/;}
;

declaration: typeSpecifier ID ';' 								{/*debug*//*printf("Declaracao de ID - %s\n",$2)*/;atualizaTabela( &tabeladeSimbolos, $2, 'd', "int");}
;

typeSpecifier: INT | VOID 										{/*debug*//*printf("tipo\n")*/;}
;

statementlist:  statement										{/*debug*//*printf("statement\n")*/;}
		| iterationStatement ';'								{/*debug*//*printf("iteration!\n")*/;}
		| statementlist ';' statement							{/*debug*//*printf("statementlist\n")*/;}
;

iterationStatement: WHILE '(' expression ')' statement 			{;}

;

statement:		ID ATRIB expression								{/*debug*//*printf("Utilizacao de ID %s\n", $1)*/;if(!atualizaUso(&tabeladeSimbolos, $1)){erroSemantico++;printf("\tERRO: %s nao foi declarado\n",$1);}}
				| imprime										{;}
;

imprime:	OUTPUT ID 											{printf("\timprimindo variavel\n");}
		|	OUTPUT NUM 											{printf("\timprimindo constante\n");}

;

expression:	expression REL aritexpression    					{/*debug*//*printf("expressionRELatritexpression")*/;}
		| aritexpression										{/*debug*//*printf("atritexpression\n")*/;}
;

aritexpression:     NUM 										{/*debug*//*printf("Numero!\n")*/;}
        | ID 													{/*debug*//*printf("Utilizacao de ID - %s\n",$1)*/;if(!atualizaUso(&tabeladeSimbolos, $1)){erroSemantico++;printf("\tERRO: %s nao foi declarado\n",$1);}}
        | aritexpression OP aritexpression 						{/*debug*//*printf("atrib expr atrib\n")*/;}
;

%%
extern FILE *yyin;
int main (int argc, char*argv[]) {
	int erroSintatico;


	printf("\tLendo o arquivo %s\n", argv[1]);
	yyin = fopen(argv[1], "r");

	if(yyin){
		//emitComment("Standard prelude:");
		emitRM("LD",mp,0,ac,"load maxaddress from location 0");
		emitRM("ST",ac,0,ac,"clear location 0");
		//emitComment("End of standard prelude.");

		//emitComment("End of execution.");
		emitRO("HALT",0,0,0,"");

		erroSintatico = yyparse ();
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

