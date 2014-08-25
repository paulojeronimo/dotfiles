#!/bin/bash

# change a file with 'sed -i'
sed_i() { sed -i "$@"; }

# Desabilita regras de firewall no iptables.
firewall_desabilitar() {
  sudo iptables -F
}
