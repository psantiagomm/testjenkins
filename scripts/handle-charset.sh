#!/bin/sh

# Ruta al archivo montado desde el ConfigMap
MOUNTED_FILE=/config/application.properties

# Verifica el charset del archivo
CHARSET=$(file -bi "$MOUNTED_FILE" | sed -n 's/.*charset=\(.*\)/\1/p')

# Si el charset no es UTF-8, conviértelo
if [ "$CHARSET" != "utf-8" ]; then
    echo "Convirtiendo $MOUNTED_FILE de $CHARSET a UTF-8"
    mv "$MOUNTED_FILE" "$MOUNTED_FILE.bak"
    iconv -f "$CHARSET" -t UTF-8 "$MOUNTED_FILE.bak" -o "$MOUNTED_FILE"
fi