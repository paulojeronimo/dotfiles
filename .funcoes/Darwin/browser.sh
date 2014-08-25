#!bin/bash

# abre o Firefox
firefox() { open -a Firefox "$@"; }

# abre o Google Chrome
chrome() { open -a 'Google Chrome' "$@"; }

# abre o Browser conforme o valor da variável BROWSE
browse() { local b=${BROWSER:-'firefox'}; $b "$@"; }
