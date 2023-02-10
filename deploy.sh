#!/bin/bash
PROJECT_ID=$1
REGION=$2
gcloud container clusters get-credentials test-cluster --region $REGION --project $PROJECT_ID
kubectl apply -f app/configmap.yaml
export CONTAINER_IMAGE=$REGION-docker.pkg.dev/$PROJECT_ID/test-repo/test-gke
envsubst < app/cronjob.yaml | kubectl apply -f -
