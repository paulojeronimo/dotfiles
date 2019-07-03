#!/bin/bash
# Autor: Paulo Jerônimo (@paulojeronimo, @paulojeronimo.info)
#
# Funções diversas

# VERBOSO é utilizado por várias funções para tornar sua execução mais verbosa
VERBOSO=${VERBOSO:-false}

# SAI_EM_FALHA é utilizado pela função falha para determinar a saída por um exit ou por um return
SAI_EM_FALHA=${SAI_EM_FALHA:-false}

# OUT é utilizado por várias funções e é um arquivo utilizado para salvar saídas de comandos
OUT=${OUT:-`d=/tmp/out_${USER}; [ -d $d ] || mkdir -p $d; echo -n $d/$$.log`}

# Verifica e exporta a plataforma
case "$OSTYPE" in
  linux*) PLATAFORMA=Linux;;
  cygwin) PLATAFORMA=Cygwin;;
  darwin*) PLATAFORMA=Darwin;;
esac
export PLATAFORMA

# Imprime "ok"
ok() { echo "ok!"; }

# Imprime "falhou!" e encerra um script (ou função).
#   Exibe o status de erro do último comando e imprime o conteúdo do arquivo $OUT 
#   Utiliza as variáveis globais $OUT e $SAI_EM_FALHA:
falha() {
  local status=$?
  local msg="$1"

  [ "$msg" ] && echo "falhou! Motivo: $msg" | tee "$OUT" || {
    echo -e "falhou!\nCódigo do erro: $status. Saída do último comando:"
    cat "$OUT"
  }
  $SAI_EM_FALHA && exit $status || return $status
}

# Imprime o nome do diretório corrente
_pwd() { echo -n $(cd "$(dirname "$(caller | cut -d ' ' -f 2-)")"; pwd); }

# Carrega variáveis e/ou funções no shell corrente
carregar_arquivo() {
  local f=$1
  local ok

  $VERBOSO && echo -n "carregando o arquivo \"$f\" ... "
  $VERBOSO && { source "$f" &> "$OUT" && ok || falha; } || source "$f"
}


# Carrega variáveis e/ou funções nos arquivos *.sh de diretórios específicos
carregar_arquivos_em() {
    local d
    local pos=0
    local ignorados
    local diretorios
    for d in "$@"
    do
        (( pos++ ))
        case $d in
            -i) 
                [ "$ignorados" ] && ignorados+=","
                ignorados+=${@:$((pos+1)):1}
                continue
                ;;
            *)
                [ $(( pos >= 1 )) -a "${@:$((pos-1)):1}" = "-i" ] && continue
                [ "$diretorios" ] && diretorios+=","
                diretorios+=$d
        esac
    done
    local OLD_IFS=$IFS
    IFS=','
    for d in $diretorios
    do
        [ -d "$d" ] || { $VERBOSO && echo "o diretório \"$d\" não existe!"; continue; }
        shopt -s nullglob
        local f
        local ignorado
        for f in "$d"/*.sh
        do
            ignorado=false
            local g
            for g in $ignorados
            do
                [ "$f" = "$g" ] && { $VERBOSO && echo "ignorando o arquivo \"$f\" ignorado!"; ignorado=true; break; }
            done
            $ignorado || carregar_arquivo "$f"
        done
        shopt -u nullglob
    done
    IFS=$OLD_IFS
}

# Show PATH, one per line
showpath() { echo $PATH | tr : '\n'; }

# change a file with 'sed -i'
sed_i() { 
  case $PLATAFORMA in
    Linux|Cygwin) sed -i "$@";;
    Darwin) sed -i '' "$@";;
  esac
}

# Change the loaded environment configured at this file
setenv() {
  local env=$1
  local DOTSTART_FILE=~/.ambiente

  if ! [[ "$env" = /* ]]; then
    env="$PWD/$env"
  fi

  if [ -f "$env" -o "$env" == /dev/null ]; then
    sed_i "s,^\(export ENVIRONMENT=\)\(.*\),\1\"$env\",g" $DOTSTART_FILE
    echo "Changes made at \"$DOTSTART_FILE\". For effect, reopen your shell."
  else
    echo "The file \"$env\" does'nt exists! Nothing was done."
  fi
}

# Testa se o usuário que está executando esta função é root e falha, caso não seja
verifica_root() {
  echo -n "Verificando se o usuário é root... "
  [ "`id -u`" -eq 0 ] && ok || falha "Este script deve ser rodado como root!"
}

# Extrai o conteúdo de um arquivo, baseado na sua extensão
extrai() {
  local file="$1"
  local cmd

  [ -r "$file" -o -h "$file" ] && {
      case "$file" in
          *.tar.bz2)   cmd="tar xvjf";;
          *.tar.gz)    cmd="tar xvzf";;
          *.bz2)       cmd="bunzip";;
          *.rar)       cmd="unrar x";;
          *.gz)        cmd="gunzip";;
          *.tar)       cmd="tar xvf";;
          *.tbz2)      cmd="tar xvjf";;
          *.tgz)       cmd="tar xvzf";;
          *.zip)       [[ $PLATAFORMA = Cygwin ]] && cmd="7za x" || cmd="unzip";;
          *.Z)         cmd="uncompress";;
          *.7z)        cmd="7za x";;
          *)           echo "'$1' não pode ser extraido através do extrai!"; return 1;;
      esac
  } || { echo "'$1' não é um arquivo válido"; return 1; }
  $cmd "$file"
}

# Verifica se uma variável está definida
#   falha caso não esteja definida
verifica_var() {
  local nome_var=$1; shift
  local var=${!nome_var}

  [ "$var" ] || falha "A variável $nome_var não está configurada!"

  case "$1" in
      --echo) echo -n "$var"
  esac
}

# Verifica se o diretório apontado pela variável passada existe
#   falha caso não exista
verifica_dir() {
  local dir=`verifica_var $1 --echo` || falha

  [ -d $dir ] || falha "O diretório $dir não existe!"
}

# Verifica se o diretório informado pelo nome da variável
#   passada como parâmetro existe. Se não existir, cria-o.
cria_dir() {
  local dir=`verifica_var $1 --echo` || falha

  [ ! -d "$dir" ] && {
      echo -n "Criando o diretório $dir... " 
      mkdir -p "$dir" &> "$OUT" && ok || falha
  } || true
}

# Expande um arquivo zipado criando um diretório com o mesmo nome
# Útil para realizar tarefas em pacotes J2EE no JBoss
expande() {
  local arquivo=$1

  [ -f $arquivo ] || { echo $arquivo inexistente!; return 1; }
  local dir=`dirname "$arquivo"`
  [ -w $dir ] || { echo sem permissão de escrita no diretório $dir!; return 1; }
  unzip -d $arquivo.tmp $arquivo > /dev/null
  mv $arquivo $arquivo.old
  mv $arquivo.tmp $arquivo
  rm $arquivo.old
}

# Comprime um diretório, criando um arquivo de mesmo nome
# Útil para realizar tarefas em pacotes J2EE no JBoss
comprime() {
  local dir=$1

  [ -d $dir ] || { echo $dir inexistente!; return 1; }
  local basename=`basename "$dir"`
  local dirpai=`dirname "$dir"`
  [ -w $dirpai ] || { echo sem permissão de escrita em $dirpai; return 1; }
  (cd $dir; zip -r ../$basename.tmp *) &> /dev/null
  rm -rf $dir
  (cd $dirpai; mv $basename.tmp $basename)
}

# Retorna true se o caminho passado é absoluto, false caso contrário
absoluto() {
  local path=$1
  [ ${path:0:1} == '/' ] && true || false
}

linka() {
  local d_origem=$1
  local d_destino=$2

  [ "$d_origem" ] || { echo "Diretório de origem não informado!"; return 1; }
  [ "$d_destino" ] || { echo "Diretório de destino não informado!"; return 2; }

  absoluto $d_destino || d_destino=$(cd $PWD/$d_destino; echo -n $PWD)

  [ -d "$d_origem" ] || { echo "Diretório de origem é inválido!"; return 3; }
  [ -d "$d_destino" ] || { echo "Diretório de destino é inválido!"; return 4; }

  cd $d_origem
  for i in `find -type f`; do
    d_destino_f=$d_destino/`dirname "$i"`
    mkdir -p "$d_destino_f"
    ln $i "$d_destino_f/`basename "$i"`"
  done
  cd - &> /dev/null
}

limpa() {
  local LIMPA_DIR=.limpa

  remove_arquivos_de() { 
    echo `cat $1` | xargs rm -rf 
  }

  limpa_config() {
    local config
    [ "$1" ] && config=${LIMPA_DIR}/$1 || config=$LIMPA_DIR/default
    [ -f "$config" ] || { echo "Arquivo $config não encontrado!"; return 1; }
    remove_arquivos_de $config
  }

  limpa_tudo() {
    local config
    for config in `find $LIMPA_DIR -type f`; do
      remove_arquivos_de $config
    done
  }

  cd
  if [ "$1" ]; then
    while [ "$1" ]; do
      case "$1" in
        --tudo) limpa_tudo;;
        *) limpa_config $1;;
      esac
      shift
    done
  else
    limpa_config
  fi
  cd - &> /dev/null
}

# http://blog.publicobject.com/2006/06/canonical-path-of-file-in-bash.html 
path_canonical_simple() {
  local dst="$1"
  cd -P -- "$(dirname -- "$dst")" &> /dev/null && echo "$(pwd -P)/$(basename -- "$dst")"
}

# http://blog.publicobject.com/2006/06/canonical-path-of-file-in-bash.html 
path_canonical() {
  local dst="$(path_canonical_simple "$1")"
  while [[ -h "$dst" ]]; do
    local linkDst="$(ls -l "$dst" | sed -r -e 's/^.*[[:space:]]*->[[:space:]]*(.*)[[:space:]]*$/\1/g')"
    if [[ -z "$(echo "$linkDst" | grep -E '^/')" ]]; then
      linkDst="$(dirname "$dst")/$linkDst"
    fi
    dst="$(path_canonical_simple "$linkDst")"
  done
  echo "$dst"
}

# Ajusta um prompt simples
prompt_simples() { export OLD_PS1=$PS1; export PS1='\$ '; }

# Retorna o prompt anterior, caso exista
prompt_anterior() { [ "$OLD_PS1" ] && { export PS1=$OLD_PS1; unset OLD_PS1; }; }

# Formata um arquivo XML preservando seus atritubos no sistema de arquivos
xml_format() {
  local f="$1"
  local tmp=${TMPDIR:-/tmp}

  cp -a "$f" "$tmp"
  xmllint --format "$tmp/$f" > "$f"
  rm "$tmp/$f"
}

# Procura por um arquivo que contenha o nome especificado (expressão regular)
#   no diretório atual e abaixo
findf() {
  find . -type f | egrep "$@"
}

# List files and dirs excluding Git files
find-not-git() {
  [ -d .git ] || echo "This dir doesn't seem to be a git repo ... Aborting"
  find . ! \( -name './.git' -o -path './.git/*' \) "$@"
}

# Procura por uma string (expressão regular), dentro de um arquivo no diretório atual e abaixo
grepf() {
  find . -type f -print0 | xargs -0 egrep "$@"
}

# Procura por uma string em arquivos java e correlatos
grepj() {
  find . -type f \( \
    -name '*.java' \
    -o -name '*.jsp' \
    -o -name '*.html' \
    -o -name '*.xhtml' \
    -o -name '*.properties' \
    \) -print0 | xargs -0 egrep "$@"
}

# Apresenta a saída do tree, por default, em modo ascii
# Geralmente, preciso que esta saída seja nesse formato para inserí-la nos meus documentos
#tree() {
#  which tree &> /dev/null && `which tree` --charset=ascii "$@" || {
#    echo 'tree is not installed!'
#  }
#}

# Vai para o diretório do projeto dotfiles
dotfiles() {
  cd "$DOTFILES_HOME"
}

# Vai para o diretório de downloads
downloads() {
  local dir=~/Downloads

  if [ -d "$dir" ]
  then
    cd "$dir"
  fi  
}

# Executa um servidor HTTP simples através do Ruby
ruby_httpd() {
  ruby -run -e httpd . -p 5000
}

# vim: set tabstop=2 shiftwidth=2 expandtab:
