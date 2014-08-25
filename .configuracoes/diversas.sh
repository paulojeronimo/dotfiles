#!/bin/bash

# VERBOSO é utilizado para tornar a execução de alguns comandos mais verbosa
VERBOSO=${VERBOSO:-true}

# SAI_EM_FALHA é utilizado pela função falha para determinar a saída por um exit ou por um return
SAI_EM_FALHA=false

# OUT é o nome de um arquivo utilizado para salvar saídas de comandos em várias funções
OUT=/tmp/out_${$}_${USER}
