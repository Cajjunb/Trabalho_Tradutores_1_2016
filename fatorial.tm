0:IN 0,0,0	* reg[r] <- valor
1:JLE 0,6(7)	* JLE if (reg[r]<=0) reg[7]=a
2:LDC 1,1,0	* reg[r]=d
3:LDC 2,1,0	* reg[r]=d
4:MUL 1,1,0	* reg[r] = reg[s] * reg[t]
5:SUB 0,0,2	* reg[r] = reg[s] - reg[t]
6:JNE 0,-3(7)	* JNE if (reg[r]!=0) reg[7]=a
7:OUT 1,0,0	* reg[r] -> saída padrão
8:HALT 0,0,0	* interrompe execução (ignora operandos)