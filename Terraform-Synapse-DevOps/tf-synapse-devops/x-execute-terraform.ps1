#===========================================================================================================#
# Description : Execute Terraform Infrastructure
# Author      : Falek Miah  
#===========================================================================================================#

## Login and setup Azure
az login
 
## Set Subscription
az account set --subscription="Visual Studio Enterprise Subscription – MPN"

## Check Subscriptions available
az account list --output table

#############################################################################################################
terraform -version

#############################################################################################################
## Execute tf-synapse-devops
#############################################################################################################
## Terraform Init & Validate
terraform init -backend-config="./backend_config/tf_state_config.hcl"
terraform validate

## Terraform Plan
terraform plan -var-file="./backend_config/backend_config.tfvars" -var-file="./terraform.tfvars" 

## Terraform Apply 
terraform apply -var-file="./backend_config/backend_config.tfvars" -var-file="./terraform.tfvars" 
# terraform apply -auto-approve

## Terraform Destroy
terraform destroy -var-file="./backend_config/backend_config.tfvars" -var-file="./terraform.tfvars" 
# terraform destroy -auto-approve