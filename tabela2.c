#include <stdlib.h> 
#include <string.h>


typedef struct{
	char *nome;					//Nome do símbolo
	int usado;					//Se foi utilizado ou não
	struct simbolo *prox;		//Próximo simbolo
} simbolo;

simbolo *tabela_simbolo = (simbolo *)0;
simbolo *put_simbolo();
simbolo *get_simbolo();

simbolo *put_simbolo(char *nome) {
	simbolo *aux;
	aux = (simbolo *) malloc (sizeof(simbolo));
	aux->nome = (char *) malloc (strlen(nome)+1); //Tamanho do nome + 1 pro null
	strcpy(aux->nome, nome);
	aux->prox = (simbolo *)tabela_simbolo;
	tabela_simbolo = aux;
	return aux;
}

simbolo *get_simbolo(char *nome) {
	simbolo *aux;
	for(aux = tabela_simbolo; aux != (simbolo *) 0; aux = (simbolo *)aux->prox) {
		if (strcmp (aux->nome, nome) == 0) {
			return aux;
		}
		return 0;
	}
}