#!/bin/bash

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## UFPR, ci312,ci702 2012-1 trabalho semestral, autor: Roberto Hexsel, 26set
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


## ####################################################################
## ATENCAO: este script supoe que a matriz de entrada tem 64x64 e foi
##          escrito apenas para testar as operacoes de acesso aas
##          memorias ROM e RAM.
##          O script devera ser adaptado para a leitura de um arquivo
##          com as dimensoes da matriz de dados e dos proprios dados.
## ####################################################################


# set -x

# se passar um argumento para script, executa gtkwave
if [ $# = 1 ] ; then WAVE="sim"
else WAVE=
fi

src="packageWires packageMatriz aux filtro tb_filtro"
sim=filtro
simulador=tb_${sim}
visual=v_${sim}.vcd

# se nao existe, cria matriz de entrada: 64x64, hexadecimal sem prefixo
out=result.txt
inp=matriz.txt
lim=63
if [ ! -s ./${inp} ] ; then
    for i in $(seq 0 ${lim}) ; do
	for j in $(seq -w 0 ${lim} | awk '//{printf "%02x\n",$1}') ; do
	    echo $j>>./${inp}
	done
    done
    touch $out
fi

# compila simulador
ghdl --clean
for F in ${src} ; do
    ghdl -a --ieee=synopsys -fexplicit ${F}.vhd 2>>log.txt || cat log.txt
done

if [[ $? == 0 ]]; then
    ghdl -e --ieee=synopsys -fexplicit ${simulador} 2>>log.txt || cat log.txt
    if [[ $? == 0 ]] && [ -x ./${simulador} ] ; then
	./${simulador} --ieee-asserts=disable --stop-time=1ms \
            --vcd=${visual} 2>${out}
        # executa gtkwave sob demanda
	test -z $WAVE  ||  gtkwave -O /dev/null ${visual} v.sav 
    else
	cat log.txt
    fi
else
    cat log.txt
fi


# processa matriz de saida gerada pelo assert no tb_filtro
if [ ./${out} -nt ./${inp} ] ; then
    sed -i '$d' $out          # remove ultima linha
    cut -d : -f 6 $out | awk '//{printf "%02x\n",$1}' >.res
    mv .res $out
    rm -f .res
    diff -a $out $inp
fi
