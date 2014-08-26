#!/bin/bash

# VERBOSO é utilizado por várias funções para tornar sua execução mais verbosa
VERBOSO=${VERBOSO:-false}

# SAI_EM_FALHA é utilizado pela função falha para determinar a saída por um exit ou por um return
SAI_EM_FALHA=${SAI_EM_FALHA:-false}

# OUT é utilizado por várias funções e é um arquivo utilizado para salvar saídas de comandos
OUT=${OUT:-`d=/tmp/out_${USER}; [ -d $d ] || mkdir -p $d; echo -n $d/$$.log`}
