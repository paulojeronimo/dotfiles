#!/bin/bash
# Autor: Paulo Jerônimo (@paulojeronimo, pj@paulojeronimo.info)
#
# Funções auxiliares para a montagem e uso de um ambiente

# Exporta as variáveis default para o ambiente
export_ambiente_default_dirs() {
   export BACKUPS_DIR=$AMBIENTE_HOME/backups
   export CONFIGURACOES_DIR=$AMBIENTE_HOME/configuracoes
   export DOCUMENTOS_DIR=$AMBIENTE_HOME/documentos
   export FERRAMENTAS_DIR=$AMBIENTE_HOME/ferramentas
   export FUNCOES_DIR=$AMBIENTE_HOME/funcoes
   export INSTALADORES_DIR=$AMBIENTE_HOME/instaladores
   export PROJETOS_DIR=$AMBIENTE_HOME/projetos
   export SCRIPTS_DIR=$AMBIENTE_HOME/scripts

   export PATH=$SCRIPTS_DIR:$PATH
}

# Carrega todas as configurações e funções do ambiente
carregar_ambiente() {
   local f

   $VERBOSO && echo "ambiente...........: \"$AMBIENTE_HOME\""
   $VERBOSO && echo "sistema operacional: `uname`"

   shopt -s nullglob
   for f in "$CONFIGURACOES_DIR"{,/`uname`}/*.sh; do carregar_arquivo "$f"; done
   for f in "$FUNCOES_DIR"{,/`uname`}/*.sh; do carregar_arquivo "$f"; done
   shopt -u nullglob
}

# funções úteis para ir a um diretório específico do ambiente
home() { verifica_var AMBIENTE_HOME; cd "$AMBIENTE_HOME" &> $OUT || falha; }
backups() { verifica_var BACKUPS_DIR; cd "$BACKUPS_DIR" &> $OUT || falha; }
configuracoes() { verifica_var CONFIGURACOES_DIR; cd "$CONFIGURACOES_HOME" &> $OUT || falha; }
documentos() { verifica_var DOCUMENTOS_DIR; cd "$DOCUMENTOS_DIR" &> $OUT || falha; }
ferramentas() { verifica_var FERRAMENTAS_DIR; cd "$FERRAMENTAS_DIR" &> $OUT || falha; }
funcoes() { verifica_var FUNCOES_DIR; cd "$FUNCOES_DIR" &> $OUT || falha; }
instaladores() { verifica_var INSTALADORES_DIR; cd "$INSTALADORES_DIR" &> $OUT || falha; }
projetos() { verifica_var PROJETOS_DIR; cd "$PROJETOS_DIR" &> $OUT || falha; }
scripts() { verifica_var SCRIPTS_DIR; cd "$SCRIPTS_DIR" &> $OUT || falha; }

# Remove o cache local de instaladores
remover_instaladores() { rm -rf "$INSTALADORES_DIR"; }

# Remove o diretório das ferramentas
remover_ferramentas() { rm -rf "$FERRAMENTAS_DIR"; }

# Recupera um diretório de instaladores salvo, caso ele exista e não haja um diretório instaladores existente
#   esta recuperação só é funciona se os instaladores estiverem no sistema de arquivos da máquina e 
#   este procedimento apenas gerará um link para a localização do instalador neste sistema de arquivos
recuperar_instaladores() {
   local bkp_instaladores_dir=$AMBIENTE_HOME.instaladores
   local instaladores=`basename "$INSTALADORES_DIR"`

   pushd "$AMBIENTE_HOME" &> /dev/null
   if [ -d "$bkp_instaladores_dir" -a ! -d "$instaladores" ]; then
      echo -n "Recuperando o diretório \"$instaladores\" ... "
      mkdir "$instaladores" &> $OUT && ok || falha
      pushd "$instaladores" &> /dev/null
      local f
      local d=${bkp_instaladores_dir##*/}
      for f in "$bkp_instaladores_dir"/*; do
         ln -s "../../$d/`basename "$f"`"
      done
      popd &> /dev/null
   fi
   popd &> /dev/null
}

# Salva os instaladores que estiverem no cache e não estiverem no diretório de instaladores salvos
salvar_instaladores() {
   local bkp_instaladores_dir=$AMBIENTE_HOME.instaladores

   if [ -d "$INSTALADORES_DIR" ]; then
      pushd "$INSTALADORES_DIR" &> /dev/null
      local f
      [ -d "$bkp_instaladores_dir" ] || mkdir -p "$bkp_instaladores_dir"
      for f in `find . -type f`; do
         cp -f "$f" "$bkp_instaladores_dir"
      done
      popd &> /dev/null
   fi
}
