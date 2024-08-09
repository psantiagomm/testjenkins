#!/bin/bash

JASYPT_CONFIG="saltGeneratorClassName=org.jasypt.salt.RandomSaltGenerator stringOutputType=base64 algorithm=PBEWITHHMACSHA512ANDAES_256 ivGeneratorClassName=org.jasypt.iv.RandomIvGenerator"
JASYPT_SCRIPT="/var/jenkins_home/jasypt/bin/encrypt.sh"

REDIS_PASSWORD=$(sh ./deploy/scripts/encrypt.sh -m $MASTER_PASS -p $REDIS_PASSWORD)
echo "La contraseña es $passencriptado"

APPLICATION_PROPERTIES=$(echo "$APPLICATION_PROPERTIES" | sed 's/^/    /2g')

sed -e 's/\${DB_HOST}/${DB_HOST}/g' \
                        -e 's/\$APPLICATION_PROPERTIES/$APPLICATION_PROPERTIES/g' \
                        -e 's/\$REDIS_PASSWORD/$REDIS_PASSWORD/g' \
                        deploy/configmap-template.yaml > configmap.yaml

cat configmap.yaml

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



# Aplicar el ConfigMap en Minikube
# kubectl apply -f configmap.yaml

rm configmap.yaml