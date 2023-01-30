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
## Execute tf-synapse-demo
#############################################################################################################
## Terraform Init & Validate
terraform init
terraform validate

## Terraform Plan
terraform plan

## Terraform Apply 
terraform apply
# terraform apply -auto-approve

## Terraform Destroy
terraform destroy
# terraform destroy -auto-approve