#!/bin/bash
source create-deployment.sh

# we are using same for image container tag for now
container=$1
port=$2
echo "uploading image to minikube"
minikube image load "${image}:latest"

create_deployment "$container"
create_service "$container"

trap 'kill $PID; exit' INT
kubectl port-forward service/$container $port:$port &
PID=$!
kubectl logs -f -l app=$container
