#!/bin/bash
echo "Actualizando los pods..."
# Nombre del Deployment
DEPLOYMENT_NAME=$PROJECT_NAME
# Espacio de nombres (namespace), si no está en el default
NAMESPACE="default"
# Ruta del endpoint al que quieres enviar la petición
ENDPOINT="/actuator/refresh"

# Obtener los nombres de los pods asociados con el Deployment
PODS=$(kubectl get pods -n ${NAMESPACE} -l app=${DEPLOYMENT_NAME} -o jsonpath="{.items[*].metadata.name}")

# Enviar una petición HTTP a cada pod
for POD in $PODS; do
    POD_IP=$(kubectl get pod $POD -n ${NAMESPACE} -o jsonpath="{.status.podIP}")
    echo "Enviando petición a $POD ($POD_IP)"
    curl -X POST http://${POD_IP}:8080${ENDPOINT}
done
