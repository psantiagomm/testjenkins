#!/bin/bash

REDIS_PASSWORD=$(sh ./deploy/scripts/encrypt.sh -m $MASTER_PASS -p $REDIS_PASSWORD)
APP_PASSWORD=$(sh ./deploy/scripts/encrypt.sh -m $MASTER_PASS -p $APP_PASSWORD)

MESSAGES_PROPERTIES=$(echo "$MESSAGES_PROPERTIES" | sed '2,$ s/^/    /')
RESILIENCE_PROPERTIES=$(sh ./deploy/scripts/normalize.sh -p $RESILIENCE_PROPERTIES)
APPLICATION_PROPERTIES2=$(echo "${APPLICATION_PROPERTIES}" | sed 's/^/    /')
APPLICATION_PROPERTIES3=$(sh ./deploy/scripts/normalize.sh -p $APPLICATION_PROPERTIES)

echo "Original"
echo $APPLICATION_PROPERTIES

echo "Con echo y sed"
echo $APPLICATION_PROPERTIES2

echo "Normalize"
echo $APPLICATION_PROPERTIES3

# Crear el archivo configmap.yaml con los valores de los parámetros
cat <<EOF > configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: testjenkins
data:
  application.properties: |
    $APPLICATION_PROPERTIES
    $APPLICATION_PROPERTIES2
    app.redis.password=$REDIS_PASSWORD
    app.password=$APP_PASSWORD
  messages.properties: |
    $MESSAGES_PROPERTIES
  resilience-dev.yaml: |
    $RESILIENCE_PROPERTIES
EOF

echo "El configmap generado es"
cat configmap.yaml



# Aplicar el ConfigMap en Minikube
# kubectl apply -f configmap.yaml

rm configmap.yaml