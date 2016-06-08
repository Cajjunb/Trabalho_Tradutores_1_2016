%{
#include <stdio.h>
#include "sintatico_tab.h"
%}

BLOCO	("comeca"|"termina")
ID	[a-zA-Z][a-zA-Z0-9]*	
NUMERO 	("+"|"-")?[0-9]+(".")[0-9]+
BRANCO	(" "|"\t")
OP		("+"|"-"|"*")
RELACAO	("<"|">"|"=")

%%
{BLOCO}\n 			{printf("Delimitador. Mais um token?\n");}
{ID}\n				{printf("Identificador. Mais um token?\n");}
{NUMERO}\n			{printf("Numero. Mais um token?\n");}
(":=")\n 			{printf("Atribuicao. Mais um token?\n");}
{RELACAO}\n 		{printf("Relacao. Mais um token?\n");}
{OP}\n 				{printf("Aritmetica. Mais um token?\n");}

.*\n 				{printf("Nao identificado\n");}


%%
int yywrap() {
 return 1;
}

/* programa principal */
main() {
  printf("Informe um token:\n");
  yylex(); /* scanner gerado por Flex */
}