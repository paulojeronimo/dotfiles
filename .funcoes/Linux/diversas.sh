#!/bin/bash

# Desabilita regras de firewall no iptables.
firewall_desabilitar() {
  sudo iptables -F
}
