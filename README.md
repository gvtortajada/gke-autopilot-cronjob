## Important: this is not meant to be used for production

# Context
Testing GKE autopilot nodejs cronjob

# Init
Creates:
* Artefact repository
* VPC and subnet
* GKE autopilot private cluster
* Cloud NAT

command (~10 minutes)
```
./init.sh project_id gcp_region
```

# Build
Build the application container and push it to artefact repository using cloud build

command
```
./build.sh project_id gcp_region
```

# Deploy
Deploy the configmap and the cronjob in GKE

command
```
./deploy.sh project_id gcp_region
```