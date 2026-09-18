location                = "East US"
resource_group_name     = "rg-azure-devops-demo"
vnet_address_space      = ["10.0.0.0/16"]
container_subnet_prefix = ["10.0.1.0/24"]

# ACR names are globally unique. Change this and Jenkinsfile if unavailable.
acr_name = "acrazuredevopsdemo12345"

container_app_name              = "ca-azure-demo"
container_apps_environment_name = "cae-azure-devops-demo"
log_analytics_name              = "law-azure-devops-demo"
container_image                 = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
