#!/bin/env bash

PROMPT_FILE=${PROMPT_FILE:-~/.simple-prompt}

prompt() {
  simple_prompt() {
    if ! [ "$OLD_PS1" ]
    then
      OLD_PS1=$PS1
      PS1='$ '
    fi
  }

  original_prompt() {
    if [ "$OLD_PS1" ]
    then
      PS1=$OLD_PS1
      unset OLD_PS1
    fi
  }

  case "$1" in
    simple)
      simple_prompt
      > $PROMPT_FILE
      ;;
    original)
      original_prompt
      rm -f $PROMPT_FILE
      ;;
    *)
      echo Invalid argument: $1
  esac
}

if [ -f $PROMPT_FILE ]
then
  prompt simple
fi
