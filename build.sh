#!/bin/bash
PROJECT_ID=$1
REGION=$2
gcloud config set project $PROJECT_ID

gcloud builds submit \
  --tag $REGION-docker.pkg.dev/$PROJECT_ID/test-repo/test-gke app