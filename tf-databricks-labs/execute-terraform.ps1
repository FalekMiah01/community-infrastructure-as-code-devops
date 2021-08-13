#===========================================================================================================#
# Description : Execute tf-databricks-labs-blog
#===========================================================================================================#
## Login into Azure
az login
az account set --subscription = '<enter_your_subscription_Id>'  ## TO COMPLETE

#############################################################################################################
Set-Location "<Enter the location of your folder>"              ## TO COMPLETE

## Terraform Init & Validate
terraform init -backend-config="./backend-config/partial_config.hcl"
terraform validate

## Terraform Plan
terraform plan -var-file="./terraform-vars.tfvars"

## Terraform Apply 
terraform apply -var-file="./terraform-vars.tfvars"

## Terraform Destroy
terraform destroy -var-file="./terraform-vars.tfvars"