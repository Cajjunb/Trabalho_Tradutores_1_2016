%{
#include <stdio.h>
#include "sintatico.tab.c" 
%}
%%
("inicio")		        {return INICIO;}
("fim")		                {return FIM;}
("while")                    {return WHILE;}
("int")                    {return INT;}
("void")                    {return VOID;}
("if")                    {return SE;}
("else")                    {return OU;}
("fimSe")                    {return FIMSE;}
("imprime")                    {return OUTPUT;}
("leia")                    {return INPUT;}
[a-zA-Z][a-zA-Z][0-9][0-9][0-9]	{yylval.cadeia=  strdup(yytext);return IDENTIFICADOR;}
("+"|"-")?[0-9]+		{yylval.val = atoi(yytext);return NUMERO;}
("<<-")				{return ATRIB;}
("+"|"-"|"*"|"/")		{return OP;}
("!="|"=")			{ return REL;}
[ \t]+				{ ;}
.|\n				{return yytext[0];}

%%
int yywrap() {
 return 1;
} 