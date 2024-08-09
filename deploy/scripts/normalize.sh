#!/bin/bash

# Inicializar variables
p=""

# Procesar las opciones usando getopts
while getopts "p:" opt; do
  case $opt in
    p) p=$OPTARG ;;
    *) echo "Opción no válida: -$OPTARG" >&2; exit 1 ;;
  esac
done

resultado=$(echo "${p}" | sed 's/^/    /')

echo $resultado

