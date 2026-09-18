pipeline {
    agent any

    environment {
        ACR_NAME        = "acrazuredevopsdemo12345"
        IMAGE_NAME      = "azure-demo"
        RESOURCE_GROUP  = "rg-azure-devops-demo"
        CONTAINER_APP   = "ca-azure-demo"
    }

    stages {

        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Check Environment") {
            steps {
                sh '''
                    echo "===== Jenkins Environment ====="
                    hostname
                    whoami

                    echo "===== Python ====="
                    which python3
                    /usr/bin/python3 --version

                    echo "===== Pip ====="
                    /usr/bin/python3 -m pip --version

                    echo "===== Azure CLI ====="
                    az version --output table

                    echo "===== Docker ====="
                    docker --version
                '''
            }
        }

        stage("Test") {
            steps {
                sh '''
                    set -e

                    echo "Creating Python virtual environment..."

                    rm -rf .venv

                    /usr/bin/python3 -m venv .venv

                    echo "Upgrading pip..."
                    .venv/bin/python -m pip install --upgrade pip

                    echo "Installing requirements..."
                    .venv/bin/python -m pip install -r app/requirements.txt

                    echo "Compiling Python application..."
                    .venv/bin/python -m py_compile app/app.py

                    echo "Python test completed successfully."
                '''
            }
        }

        stage("Azure Login") {
            steps {
                withCredentials([
                    azureServicePrincipal(
                        credentialsId: "azure-service-principal",
                        subscriptionIdVariable: "AZURE_SUBSCRIPTION_ID",
                        clientIdVariable: "AZURE_CLIENT_ID",
                        clientSecretVariable: "AZURE_CLIENT_SECRET",
                        tenantIdVariable: "AZURE_TENANT_ID"
                    )
                ]) {
                    sh '''
                        set -e

                        echo "======================================"
                        echo "Logging into Azure..."
                        echo "======================================"

                        az login \
                            --service-principal \
                            --username "$AZURE_CLIENT_ID" \
                            --password "$AZURE_CLIENT_SECRET" \
                            --tenant "$AZURE_TENANT_ID" \
                            --output none

                        az account set \
                            --subscription "$AZURE_SUBSCRIPTION_ID"

                        echo "Azure login successful."

                        az account show \
                            --query "{Name:name, Subscription:id, Tenant:tenantId}" \
                            --output table
                    '''
                }
            }
        }

        stage("Docker Build") {
            steps {
                sh '''
                    set -e

                    echo "======================================"
                    echo "Building Docker image..."
                    echo "======================================"

                    docker build \
                        -t ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${BUILD_NUMBER} \
                        ./app

                    echo "Docker image built successfully."

                    docker images | grep "${IMAGE_NAME}"
                '''
            }
        }

        stage("Push Image to ACR") {
            steps {
                sh '''
                    set -e

                    echo "======================================"
                    echo "Logging into Azure Container Registry..."
                    echo "======================================"

                    az acr login \
                        --name ${ACR_NAME}

                    echo "Pushing image to ACR..."

                    docker push \
                        ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${BUILD_NUMBER}

                    echo "Image pushed successfully."
                '''
            }
        }

        stage("Deploy to Container Apps") {
            steps {
                sh '''
                    set -e

                    echo "======================================"
                    echo "Deploying to Azure Container Apps..."
                    echo "======================================"

                    az containerapp update \
                        --name ${CONTAINER_APP} \
                        --resource-group ${RESOURCE_GROUP} \
                        --image ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${BUILD_NUMBER}

                    echo "Container App deployment completed."
                '''
            }
        }

        stage("Verify") {
            steps {
                sh '''
                    set -e

                    echo "======================================"
                    echo "Verifying Container App..."
                    echo "======================================"

                    FQDN=$(az containerapp show \
                        --name ${CONTAINER_APP} \
                        --resource-group ${RESOURCE_GROUP} \
                        --query properties.configuration.ingress.fqdn \
                        --output tsv)

                    echo "======================================"
                    echo "Application URL:"
                    echo "https://${FQDN}"
                    echo "======================================"
                '''
            }
        }
    }

    post {
        always {
            sh '''
                az logout || true
                rm -rf .venv
            '''
        }

        success {
            echo "======================================"
            echo "PIPELINE COMPLETED SUCCESSFULLY!"
            echo "======================================"
        }

        failure {
            echo "======================================"
            echo "PIPELINE FAILED!"
            echo "Check the failed stage logs."
            echo "======================================"
        }
    }
}
