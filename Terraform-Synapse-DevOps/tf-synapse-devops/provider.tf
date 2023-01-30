#######################################################################################################################
# Provider
#######################################################################################################################

# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.24.0"
    }
  }
}

# Configure the azurerm provider
provider "azurerm" {
  client_id         = var.client_id
  client_secret     = var.client_secret
  tenant_id         = var.tenant_id
  subscription_id   = var.subscription_id
  features {}
}

#######################################################################################################################
#### Backend-Config
#######################################################################################################################

## Configure the AzureRM tfstate Name
terraform {
    backend "azurerm" {
        key                  = "tfsynapsedevops.dev.terraform.tfstate"
        container_name       = var.tf_state_backend_container_name
        storage_account_name = var.tf_state_backend_storage_account_name
        resource_group_name  = var.tf_state_backend_resource_group_name
        subscription_id      = var.subscription_id
    }
}