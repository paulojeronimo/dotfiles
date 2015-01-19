#!/bin/bash

# Informa o nome da distribuição Linux que está sendo executada
distro() {
  echo $(lsb_release -i | awk -F: '{print $2}')
}

# Desabilita regras de firewall no iptables.
firewall_desabilitar() {
  sudo iptables -F
}

# Simula o pbcopy do OS X. (requer a instalação do pacote xsel)
pbcopy() {
  xsel --clipboard --input
}

# Simula o pbpaste do OS X. (requer a instalação do pacote xsel)
pbpaste() {
  xsel --clipboard --output
}

# vim: set tabstop=2 shiftwidth=2 expandtab:
