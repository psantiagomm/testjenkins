#!/bin/bash

sed -i "s|image: testjenkins:.*|image: ${DOCKER_REGISTRY}/${IMAGE_FULL_NAME}|" deployment.yaml

cat deployment.yaml

echo "Se configura JASYPT_ENCRYPTOR_PASSWORD"
echo $MASTER_PASS;

kubectl set env deployment/testjenkins JASYPT_ENCRYPTOR_PASSWORD=$MASTER_PASS

kubectl apply -f deployment.yaml