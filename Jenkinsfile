pipeline {
    agent any

    environment {
        ACR_NAME = "acrazuredevopsdemo12345"
        IMAGE_NAME = "azure-demo"
        RESOURCE_GROUP = "rg-azure-devops-demo"
        CONTAINER_APP = "ca-azure-demo"
    }

    stages {
        stage("Checkout") {
            steps { checkout scm }
        }

        stage("Test") {
            steps {
                sh """
                    python3 -m pip install -r app/requirements.txt
                    python3 -m py_compile app/app.py
                """
            }
        }

        stage("Azure Login") {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "azure-service-principal",
                        usernameVariable: "AZURE_CLIENT_ID",
                        passwordVariable: "AZURE_CLIENT_SECRET"
                    ),
                    string(credentialsId: "azure-tenant-id", variable: "AZURE_TENANT_ID"),
                    string(credentialsId: "azure-subscription-id", variable: "AZURE_SUBSCRIPTION_ID")
                ]) {
                    sh """
                        az login --service-principal                           --username "$AZURE_CLIENT_ID"                           --password "$AZURE_CLIENT_SECRET"                           --tenant "$AZURE_TENANT_ID"
                        az account set --subscription "$AZURE_SUBSCRIPTION_ID"
                    """
                }
            }
        }

        stage("Docker Build") {
            steps {
                sh """
                    docker build -t ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${BUILD_NUMBER} ./app
                """
            }
        }

        stage("Push Image to ACR") {
            steps {
                sh """
                    az acr login --name ${ACR_NAME}
                    docker push ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${BUILD_NUMBER}
                """
            }
        }

        stage("Deploy to Container Apps") {
            steps {
                sh """
                    az containerapp update                       --name ${CONTAINER_APP}                       --resource-group ${RESOURCE_GROUP}                       --image ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${BUILD_NUMBER}
                """
            }
        }

        stage("Verify") {
            steps {
                sh """
                    az containerapp show                       --name ${CONTAINER_APP}                       --resource-group ${RESOURCE_GROUP}                       --query properties.configuration.ingress.fqdn                       --output tsv
                """
            }
        }
    }

    post {
        always { sh "az logout || true" }
    }
}
