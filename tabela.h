//posicoa: posição na memória que se encontra
//externo: diz se rótulo é externo ou não
//section: diz em qual seção o rótulo percente. Aceita somente 't', SECTION TEXT, e 'd', SECTION DATA
typedef struct{
    char 			simbolo[257];
    char 			posicao;
    //bool 			externo;
    //int  			linha;
    int				usado;
    char 			Tipo[31];
    struct tipoTS 	*prox;
    //int				id;
}tipoTS; //tabela de símbolos
