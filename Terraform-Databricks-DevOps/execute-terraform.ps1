#===========================================================================================================#
# Description : Execute Terraform Infrastructure
# Author      : Falek Miah 
# Created Date: 16/09/2019 
#===========================================================================================================#

# ## Login and setup Azure
# az login

# ## Check Subscriptions available
# az account list --output table
 
# ## Set Subscription
# az account set --subscription="AdvancingAnalytics_6000"
# az account set --subscription="Visual Studio Enterprise Subscription – MPN"

#############################################################################################################
Clear-Host

## Set location of tf-templates
Set-Location "..\AppliedInfraAsCode\Terraform-DBX-Session-Prep"

terraform -version

#############################################################################################################
## tf-databricks-labs-demo
#############################################################################################################

## Terraform Init
terraform init

## Terraform Validate
terraform validate

## Terraform Plan
terraform plan

## Terraform Apply 
terraform apply
terraform apply -auto-approve

## Terraform Destroy
terraform destroy -auto-approve


#############################################################################################################
## Terraform Plan Output
#############################################################################################################
terraform plan -out="plan.out"
terraform show -json "plan.out" > "plan.json"

# terraform graph | dot -Tsvg > graph.svg


