#!/bin/bash
PROJECT_ID=$1
REGION=$2
MY_IP=$(curl ifconfig.me)
echo $MY_IP
gcloud config set project $PROJECT_ID
gcloud services enable compute.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable artifactregistry.googleapis.com

gcloud compute networks create test-vpc \
    --project=$PROJECT_ID \
    --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks subnets create test-subnet \
    --project=$PROJECT_ID \
    --range=10.128.0.0/24 --stack-type=IPV4_ONLY \
    --network=test-vpc --region=$REGION \
    --enable-private-ip-google-access


gcloud artifacts repositories create test-repo \
    --project=$PROJECT_ID \
    --repository-format=docker \
    --location=$REGION \
    --description="Docker repository"

gcloud container clusters create-auto test-cluster \
    --project $PROJECT_ID \
    --region $REGION --release-channel regular \
    --enable-private-nodes --enable-master-authorized-networks \
    --master-authorized-networks $MY_IP/32 \
    --network test-vpc --subnetwork test-subnet \
    --cluster-ipv4-cidr "/17" --services-ipv4-cidr "/22"

gcloud compute routers create nat-router \
    --network test-vpc \
    --region $REGION

gcloud compute routers nats create nat-config \
    --router-region $REGION \
    --router nat-router \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips

PN=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
echo $PN
gcloud artifacts repositories add-iam-policy-binding test-repo \
    --location=$REGION \
    --member=serviceAccount:$PN-compute@developer.gserviceaccount.com \
    --role="roles/artifactregistry.reader"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$PN-compute@developer.gserviceaccount.com \
    --role=roles/logging.logWriter