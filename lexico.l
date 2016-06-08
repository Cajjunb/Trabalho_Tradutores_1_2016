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
("imprime")                    {return OUTPUT;}
[a-zA-Z][a-zA-Z][0-9][0-9][0-9]	{yylval.cadeia=  strdup(yytext);return ID;}
("+"|"-")?[0-9]+		{return NUM;}
("<<-")				{return ATRIB;}
("+"|"-"|"*"|"/")		{return OP;}
("!="|"=")			{ return REL;}
[ \t]+				{ ;}
.|\n				{return yytext[0];}

%%
int yywrap() {
 return 1;
} 