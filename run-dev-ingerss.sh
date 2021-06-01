#!/bin/bash
source create-deployment.sh

# we are using same for image container tag for now
container=$1
port=$2
debugPort=$3

kubectl delete services spring-demo
kubectl delete deployment spring-demo

eval $(minikube docker-env)
cd ./spring-boot 
gradle build
docker-compose build
cd ..

sleep 3

# echo "deleting old image from minikube"
# minikube image rm docker.io/library/${container}:latest
# echo "uploading image to minikube"
# minikube image load "${container}:latest"

create_deployment "$container" "$port" "$debugPort"
create_service "$container" "$port" "$debugPort"

while :
do
  sleep 2
  ROLLOUT_STATUS="$(kubectl rollout status deployment/$container)"
  echo $ROLLOUT_STATUS
  if [[ "$ROLLOUT_STATUS" == *"successfully rolled out"* ]]; then 
    break;
  fi
done
sleep 5
# trap 'kill $PID2; exit' INT
# kubectl port-forward service/$container $port:$port &
# PID2=$!

trap 'kill $PID3; exit' INT
kubectl port-forward service/$container $debugPort:$debugPort &
PID3=$!

kubectl logs -f -l app=$container
