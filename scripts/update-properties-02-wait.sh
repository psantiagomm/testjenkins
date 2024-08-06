#!/bin/bash
echo "Esperando un minuto para la actualización de los pods..."
wait_time=90
# Bucle para contar los segundos
for ((i=wait_time; i>0; i=i-10)); do
    echo "Quedan $i segundos..."
    sleep 10
done

echo "¡Tiempo de espera completado!"