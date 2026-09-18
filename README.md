# Azure DevOps Demo

GitHub → Jenkins → Docker → Azure Container Registry → Azure Container Apps

## Repository

app/
- app.py
- requirements.txt
- Dockerfile

terraform/
- main.tf
- variables.tf
- outputs.tf
- providers.tf
- networking.tf
- acr.tf
- container-app.tf
- terraform.tfvars

Jenkinsfile
.gitignore
README.md

## Prerequisites

Azure subscription, GitHub repository, Jenkins, Docker, Azure CLI, Python 3 and Terraform.

## Terraform

cd terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply

ACR names are globally unique. Change `acr_name` in terraform.tfvars and the matching ACR_NAME in Jenkinsfile if needed.

## Jenkins

Create a Pipeline connected to this GitHub repository.

Required credentials:
- azure-service-principal: username = Azure client ID, password = client secret
- azure-tenant-id: Secret Text
- azure-subscription-id: Secret Text

The Jenkins agent needs Docker, Azure CLI, Git and Python 3.

## Pipeline

Checkout → Test → Azure Login → Docker Build → ACR Push → Container Apps Deploy → Verify

## Test

After deployment:

az containerapp show   --name ca-azure-demo   --resource-group rg-azure-devops-demo   --query properties.configuration.ingress.fqdn   --output tsv

Open the resulting HTTPS URL.

## Security

Do not commit Azure secrets or Terraform state. For production, use remote Terraform state, least-privilege RBAC, secret management and federated/workload identity authentication where supported.
# azure-devops-demo
