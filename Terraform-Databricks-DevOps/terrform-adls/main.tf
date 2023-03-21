#######################################################################################################################
# Provider
#######################################################################################################################
## Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.90.0"
    }
  }
}

provider "azurerm" {
  features {}
}

#######################################################################################################################
#### Input Variables
#######################################################################################################################
variable "azure_region" {
  description = "Azure region the resource is located"
  default     = "UK South"
}

variable "prefix" {
  description = "Prefix for project"
  default     = "tfsqlbitsadls"
}

locals {
  tags = {
    Environment = "Dev"
    Owner       = "Falek Miah"
    Env_Prefix  = "dev-${var.prefix}"
  }
}

#######################################################################################################################
# Resource Group
#######################################################################################################################
# Create Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}"
  location = var.azure_region
}

#######################################################################################################################
# Data Lake
#######################################################################################################################

# Create Storage Account - Data Lake 
resource "azurerm_storage_account" "adls" {
  name                     = "${var.prefix}adls"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.azure_region
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Cool"
  tags                     = local.tags
}

# Create Storage Container
resource "azurerm_storage_container" "adls_cont" {
  name                  = "main"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"
}

#######################################################################################################################
#### Output
#######################################################################################################################
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "azure_region" {
  value = azurerm_resource_group.rg.location
}