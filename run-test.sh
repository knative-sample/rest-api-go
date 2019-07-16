#!/bin/bash

SVC_NAME="stock-service-example"

export INGRESSGATEWAY=istio-ingressgateway
export GATEWAY_IP=`kubectl get svc $INGRESSGATEWAY --namespace istio-system --output jsonpath="{.status.loadBalancer.ingress[*]['ip']}"`
export DOMAIN_NAME=`kubectl get route ${SVC_NAME} --output jsonpath="{.status.url}"| awk -F/ '{print $3}'`

echo "GATEWAY_IP: ${GATEWAY_IP}"
kubectl get ksvc ${SVC_NAME} --output=custom-columns=NAME:.metadata.name,DOMAIN:.status.domain

time curl -H "Host: ${DOMAIN_NAME}" http://${GATEWAY_IP} -v
