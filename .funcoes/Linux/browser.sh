#!bin/bash

# abre o Firefox
firefox() { `which firefox` "$@"; }

# abre o Google Chrome
chrome() { google-chrome "$@"; }

# abre o Browser conforme o valor da variável BROWSE
browse() { local b=${BROWSER:-'firefox'}; $b "$@"; }
