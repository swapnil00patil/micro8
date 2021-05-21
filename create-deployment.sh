#!/bin/bash


create_deployment () {
  container=$1
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
        - containerPort: 8080
        imagePullPolicy: 'Never'
EOF
}

create_service () {
  container=$1
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
      port: 8080
      targetPort: 8080
    selector:
        app: ${container}
    type: NodePort
EOF
}