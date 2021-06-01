#!/bin/bash


create_deployment () {
  container=$1
  port=$2
  debugPort=$3
  kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${container}
  labels:
    app: ${container}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${container}
  template:
    metadata:
      labels:
        app: ${container}
    spec:
      containers:
      - name: ${container}
        image: docker.io/library/${container}:latest
        ports:
        - containerPort: ${port}
          name: run-port
        - containerPort: ${debugPort}
          name: debug-port
        imagePullPolicy: 'Never'
EOF
}

create_service () {
  container=$1
  port=$2
  debugPort=$3
  kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
    name: ${container}
    labels:
        app: ${container}
spec:
    ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: ${port}
    - name: debug
      protocol: TCP
      port: ${debugPort}
      targetPort: ${debugPort}
    selector:
        app: ${container}
    type: NodePort
EOF
}