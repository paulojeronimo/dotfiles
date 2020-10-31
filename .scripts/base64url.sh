#!/bin/bash

usage() {
  cat <<EOF
RFC 7515/RFC 4648 base64url encoding and decoding without padding.

usage:
       echo abdc | base64url -E
       base64url -E abdc
       base64url.sh -D YWJjZA
       echo YWJjZA | base64url.sh -D

EOF
}

encode() {
  tr -d '[:space:]' | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =
}

decode() {
  local str
  local pad
  str=$(tr -d '[:space:]' | tr -- '-_' '+/')
  pad=$(( (4 - ${#str} % 4) %4 ))
  printf "%s%s" "$str" "$(printf '=%.0s' $(seq $pad))" | openssl base64 -d -A
}

if [[ $1 == -E ]]
then
  if [[ -z $2 ]]
  then
    encode
  else
    printf "%s" "$2" | encode | xargs printf "%s\\n"
  fi

elif [[ $1 == -D ]]
then
  if [[ -z $2 ]]
  then
    decode
  else
    printf "%s" "$2" | decode | xargs printf "%s\\n"
  fi

else
  usage
fi

