#include "tabela.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
//VARIAVEIS GLOBAIS
int erroSemantico = 0;
tipoTS *tabeladeSimbolos = NULL;

void atualizaTabela( tipoTS **tabeladeSimbolos, char simbolo[], char posicao, char Tipo[]){
    //Cria a nova ficha de dado para inserir na tabela
    tipoTS *novo = (tipoTS*)malloc(sizeof(tipoTS));
    strcpy(novo->simbolo, simbolo);
    novo->posicao = posicao;
    novo->usado   = 0;
    novo->prox    = NULL;
    strcpy(novo->Tipo, Tipo);
    //Caso seja o primeiro
    if (*tabeladeSimbolos == NULL){
        *tabeladeSimbolos = novo;
    }else{
        tipoTS *aux     = *tabeladeSimbolos;
        while(aux->prox != NULL){
            printf("\t %p \t %s \t%c\t %s \n",aux,aux->simbolo,aux->posicao,aux->Tipo);
            aux = (tipoTS*)aux->prox;
        }
        aux->prox = (tipoTS*)novo;
    }
    return;
}

void imprimeTabela(tipoTS **tabeladeSimbolos){
    printf("\tSimbolo\tposicao\tusado\tTipo\n"); 
    //Caso seja o primeiro
    if (*tabeladeSimbolos != NULL){
        tipoTS *aux     = (tipoTS*)*tabeladeSimbolos;
        while(aux  != NULL){
            printf("\t%s\t%d\t%s\n",
                    aux->simbolo,
                    aux->usado,
                    aux->Tipo); 
            aux = (tipoTS*)aux->prox;
        }
    }
    printf("\tFIM\n");
    return;
}


int verificaNaoUsado(tipoTS **tabeladeSimbolos){
    int achado = 0;
    //Caso seja o primeiro
    if (*tabeladeSimbolos != NULL){
        tipoTS *aux     = (tipoTS*)*tabeladeSimbolos;
        while(aux  != NULL){            
            if (aux->usado == 0){
                if (achado == 0){
                    printf("\t##########################################\n\tWARNING:TABELA DE VARIAVEIS NAO UTILIZADAS\n");
                }
                printf("\t%s\t%d\t%s\n",
                    aux->simbolo,
                    aux->usado,
                    aux->Tipo); 
                achado++;
            }
            aux = (tipoTS*)aux->prox;
        }
        if (achado > 0){
            printf("\t##########################################\n");
        }
    }
    return achado;
}



int atualizaUso(tipoTS **tabeladeSimbolos, char *simbolo){
    int achado = 0;
    //Caso seja o primeiro
    if (*tabeladeSimbolos != NULL){
        tipoTS *aux     = (tipoTS*)*tabeladeSimbolos;
        while(aux  != NULL){            
            
            if (strcmp(aux->simbolo,simbolo) == 0){
                aux->usado = 1;
                achado = 1;
            }
            aux = (tipoTS*)aux->prox;
        }
    }
    return achado;
}

