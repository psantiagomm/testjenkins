#!/bin/bash

sed -i 's|image: testjenkins:.*|image: ${DOCKER_REGISTRY}/${IMAGE_FULL_NAME}|' deployment.yaml

cat deployment.yaml

kubectl set env deployment/testjenkins JASYPT_ENCRYPTOR_PASSWORD=$MASTER_PASS

kubectl apply -f deployment.yaml