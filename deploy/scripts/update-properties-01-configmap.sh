#!/bin/bash

REDIS_PASSWORD=$(sh ./deploy/scripts/encrypt.sh -m $MASTER_PASS -p $REDIS_PASSWORD)
APP_PASSWORD=$(sh ./deploy/scripts/encrypt.sh -m $MASTER_PASS -p $APP_PASSWORD)

MESSAGES_PROPERTIES=$(echo "$MESSAGES_PROPERTIES" | sed 's/^/    /2g')
RESILIENCE_PROPERTIES=$(echo "$RESILIENCE_PROPERTIES" | sed 's/^/    /2g')
APPLICATION_PROPERTIES=$(echo "${APPLICATION_PROPERTIES}" | sed '1{h;d};2,$s/^/    /')

# Crear el archivo configmap.yaml con los valores de los parámetros
cat <<EOF > configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: testjenkins
data:
  application.properties: |
    $APPLICATION_PROPERTIES
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