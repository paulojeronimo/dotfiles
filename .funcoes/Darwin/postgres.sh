#!/bin/bash
# Autor: Paulo Jerônimo (pj@paulojeronimo, @paulojeronimo)
#
# Funções específicas para trabalho com o Postgres no OS X

postgres_start() { sudo launchctl start com.edb.launchd.postgresql-9.3; }
postgres_stop() { sudo launchctl stop com.edb.launchd.postgresql-9.3; }
