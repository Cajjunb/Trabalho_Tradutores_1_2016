%{
#include <stdio.h>
%}

ID	[a-zA-Z][a-zA-Z0-9]*	
NUMERO 	("+"|"-")?[0-9]+(".")[0-9]+
BRANCO	(" "|"\t")
OP		("+"|"-"|"*")
BLOCO	("comeca"|"termina")

%%
{ID}\n				{printf("Identificador. Mais um token?\n");}
{NUMERO}\n			{printf("Numero. Mais um token?\n");}

{ID}({BRANCO})*(":=")({BRANCO})*({ID}|{NUMERO})\n {printf("Atribuicao. Mais um token?\n");}
{ID}({BRANCO})*("<"|">"|"=")({BRANCO})*({ID}|{NUMERO})\n {printf("Relacao. Mais um token?\n");}

({ID}|{NUMERO})({BRANCO})*{OP}({BRANCO})*({ID}|{NUMERO})(({BRANCO})*{OP}({BRANCO})*({ID}|{NUMERO}))*\n {printf("Aritmetica. Mais um token?\n");}

{BLOCO}\n 			{printf("Delimitador. Mais um token?\n");}



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