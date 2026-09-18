variable "location" {
  type    = string
  default = "East US"
}

variable "resource_group_name" {
  type    = string
  default = "rg-azure-devops-demo"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "container_subnet_prefix" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "acr_name" {
  type    = string
  default = "acrazuredevopsdemo12345"
}

variable "container_app_name" {
  type    = string
  default = "ca-azure-demo"
}

variable "container_apps_environment_name" {
  type    = string
  default = "cae-azure-devops-demo"
}

variable "log_analytics_name" {
  type    = string
  default = "law-azure-devops-demo"
}

variable "container_image" {
  type    = string
  default = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}
