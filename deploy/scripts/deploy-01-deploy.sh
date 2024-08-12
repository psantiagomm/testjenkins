#!/bin/bash

PROJECT=$PROJECT_NAME
IMAGE="${DOCKER_REGISTRY}/${IMAGE_FULL_NAME}"

awk -v project="$PROJECT" -v image="$IMAGE" -v masterPass="$MASTER_PASS" '
{
    gsub(/{{PROJECT}}/, project);
    gsub(/{{IMAGE}}/, image);
    gsub(/{{MASTER_PASS}}/, masterPass);
    print;
}' ${PROJECT_PATH}deploy/deployment.yaml > deployment.yaml

kubectl apply -f deployment.yaml

rm deployment.yaml