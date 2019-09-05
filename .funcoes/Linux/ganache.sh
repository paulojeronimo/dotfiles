#!/usr/local/env bash
#
# Author: Paulo Jeronimo <paulojeronim@gmail.com>
#
# ganache-cli (https://github.com/trufflesuite/ganache-cli) helper functions

export gc_host=${gc_host:-127.0.0.1}

gc() {
  local gc_log=~/gc.log

  running() { echo running pid=$1; }
  stoped() { echo stoped; }

  gc_version() {
    ganache-cli --version
  }

  gc_start() {
    local pid
    pid=`gc_pid` && running $pid || { \
      ganache-cli --host $gc_host &> $gc_log &
    }
  }

  gc_pid() {
    local result
    set -o pipefail
    pgrep -a node | grep ganache-cli | awk '{print $1}'
    result=$?
    set +o pipefail
    return $result
  }

  gc_status() {
    local pid
    pid=`gc_pid` && running $pid || stoped
  }

  gc_stop() {
    local pid
    pid=`gc_pid` && kill -s SIGTERM $pid
    wait $pid 2> /dev/null
    stoped
  }

  gc_log() {
    local op=${1:-view}
    case "$op" in
      view) vim -R $gc_log;;
      tail) tail -f $gc_log;;
    esac
  }

  gc_seedphrase() {
    grep "Mnemonic: " $gc_log
  }

  local op=${1:-status}
  shift
  if type gc_$op &> /dev/null
  then
    gc_$op "$@"
  else
    echo "\"$op\" is not a valid option"
  fi
}
