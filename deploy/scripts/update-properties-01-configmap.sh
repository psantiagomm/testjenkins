#!/bin/bash

JASYPT_CONFIG="saltGeneratorClassName=org.jasypt.salt.RandomSaltGenerator stringOutputType=base64 algorithm=PBEWITHHMACSHA512ANDAES_256 ivGeneratorClassName=org.jasypt.iv.RandomIvGenerator"
JASYPT_SCRIPT="/var/jenkins_home/jasypt/bin/encrypt.sh"

passencriptado=$(sh ./encrypt.sh -m $MASTER_PASS -p $REDIS_PASSWORD)
echo "La contraseña es $passencriptado"

# Crear el archivo configmap.yaml con los valores de los parámetros
cat <<EOF > configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: testjenkins
data:
  application.properties: |
$(echo "${APPLICATION_PROPERTIES}" | sed 's/^/    /')
    app.redis.password=ENC($($JASYPT_SCRIPT input="$REDIS_PASSWORD" password="$MASTER_PASS" $JASYPT_CONFIG | tail -n 3 | head -n 1))
    app.password=ENC($($JASYPT_SCRIPT input="$APP_PASSWORD" password="$MASTER_PASS" $JASYPT_CONFIG | tail -n 3 | head -n 1))
  messages.properties: |
$(echo "${MESSAGES_PROPERTIES}" | sed 's/^/    /')
  resilience-dev.yaml: |
$(echo "${RESILIENCE_PROPERTIES}" | sed 's/^/    /')
EOF

cat configmap.yaml

# Aplicar el ConfigMap en Minikube
kubectl apply -f configmap.yaml

rm configmap.yaml