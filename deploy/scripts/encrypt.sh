#!/bin/bash

JASYPT_CONFIG="saltGeneratorClassName=org.jasypt.salt.RandomSaltGenerator stringOutputType=base64 algorithm=PBEWITHHMACSHA512ANDAES_256 ivGeneratorClassName=org.jasypt.iv.RandomIvGenerator"
JASYPT_SCRIPT="/var/jenkins_home/jasypt/bin/encrypt.sh"

# Inicializar variables
m=""
p=""

# Procesar las opciones usando getopts
while getopts "m:p:" opt; do
  case $opt in
    m) m=$OPTARG ;;
    p) p=$OPTARG ;;
    *) echo "Opción no válida: -$OPTARG" >&2; exit 1 ;;
  esac
done

resultado="ENC($($JASYPT_SCRIPT input="$p" password="$m" $JASYPT_CONFIG | tail -n 3 | head -n 1))"

echo $resultado

