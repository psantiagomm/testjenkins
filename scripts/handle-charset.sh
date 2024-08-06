#!/bin/sh

# Directorio donde se montan los archivos desde el ConfigMap
CONFIG_DIR="/config"

# Recorrer todos los archivos en el directorio
for file in "$CONFIG_DIR"/*; do
    if [ -f "$file" ]; then
        # Verifica el charset del archivo
        CHARSET=$(file -bi "$file" | sed -n 's/.*charset=\(.*\)/\1/p')

        # Si el charset no es UTF-8, conviértelo
        if [ "$CHARSET" != "utf-8" ]; then
            echo "Convirtiendo $file de $CHARSET a UTF-8"
            recode  ..utf-8 "$file"
        fi
    fi
done