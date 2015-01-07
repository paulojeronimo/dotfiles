#!/bin/bash
# Autor: Paulo Jerônimo (pj@paulojeronimo, @paulojeronimo)
#
# Funções específicas para trabalho com o PostgreSQL no OS X
#
# Refs:
# https://www.codefellows.org/blog/three-battle-tested-ways-to-install-postgresql
# http://kidsreturn.org/2012/03/install-postgresql-on-mac-lion-via-homebrew/
# http://www.moncefbelyamani.com/how-to-install-postgresql-on-a-mac-with-homebrew-and-lunchy/
# http://www.gotealeaf.com/blog/how-to-install-postgresql-on-a-mac

POSTGRES_LOG=/usr/local/var/postgres/server.log

postgres_install() {
    brew install postgresql
    initdb /usr/local/var/postgres
    postgres_start
    sleep 2
    createuser -s postgres
}

postgres_remove() {
    postgres_stop
    rm -rf /usr/local/var/postgres
}

postgres_start() {
    pg_ctl -D /usr/local/var/postgres -l $POSTGRES_LOG start
}

postgres_showlog() {
    tail -f $POSTGRES_LOG
}

postgres_stop() { 
    pg_ctl -D /usr/local/var/postgres stop -s -m fast
}
