#include "tabela.c"
#include <stdio.h>

int main(){
	int i = 0;
    char 			simbolo[257];
    char 			posicao;
    //bool 			externo;
    //int  			linha;
    int				usado;
    char 			Tipo[31];
    tipoTS *tabeladeSimbolos;
	for (i = 0; i < 3; ++i){
		printf("\tDigite um simbolo\n");
		scanf("%s%*c",simbolo);
		printf("\tDigite uma posica\n");
		scanf("%c%*c",&posicao);
		printf("\tDigite se foi usado ou nao\n");
		scanf("%d%*c",&usado);
		printf("\tDigite o tipo\n");
		scanf("%s%*c",Tipo);
		printf("\t##########################PROXIMO###################\n");
		atualizaTabela( tabeladeSimbolos,  simbolo,  posicao, Tipo);
	}
	imprimeTabela(tabeladeSimbolos);
	return 0 ;
}