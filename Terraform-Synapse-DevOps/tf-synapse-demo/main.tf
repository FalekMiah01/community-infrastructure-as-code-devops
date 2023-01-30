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

provider "azurerm" {
  features {}
  subscription_id = "f9197e0e-1333-42c2-84c6-b0b2e48e084a"
}

#######################################################################################################################
# Data Source
#######################################################################################################################

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

#######################################################################################################################
#### Input Variables
#######################################################################################################################

variable "azure_region" {
  description = "Azure region the resource is located"
  default     = "UK South"
}

variable "prefix" {
  description = "Prefix for project"
  default     = "tfsynapsedemo"
}

variable "another_user_object_id" {
  type        = string
  description = "Another User: Anna"
  default     = "7d19576b-b306-40e7-8311-2da98667349c"
}

locals {
  tags = {
    Environment = "Dev"
    Owner       = "Falek Miah"
  }
}

#######################################################################################################################
# Resource Group
#######################################################################################################################

# Create Azure Resource Group (resourceType & referenceName)
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
  access_tier              = "Hot"
  tags                     = local.tags
}

# Create Storage Container
resource "azurerm_storage_container" "adls_cont" {
  name                  = "main"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"
}

# Create Storage File System
resource "azurerm_storage_data_lake_gen2_filesystem" "adls_fs" {
  name               = "${var.prefix}-adlsfs"
  storage_account_id = azurerm_storage_account.adls.id
}

#######################################################################################################################
# Synapse
#######################################################################################################################

# Create Synpase Workspace
resource "azurerm_synapse_workspace" "synapse" {
  name                                 = "${var.prefix}-synw"
  resource_group_name                  = azurerm_resource_group.rg.name
  location                             = var.azure_region
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.adls_fs.id
  sql_administrator_login              = "adminuser"
  sql_administrator_login_password     = "n0tVery$ecure"

  aad_admin {
    login     = "AzureAD Admin"
    object_id = data.azurerm_client_config.current.object_id
    tenant_id = data.azurerm_subscription.current.tenant_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

# Create Synapse Firewall
resource "azurerm_synapse_firewall_rule" "synapse_firewall" {
  name                 = "AllowAll"
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}


#################################################
# Synapse Components - Synapse Role
#################################################
# Wait 30 seconds
resource "time_sleep" "wait_x_seconds" {
  depends_on = [azurerm_synapse_workspace.synapse,
  azurerm_synapse_firewall_rule.synapse_firewall]
  create_duration = "30s"
}

# Create Synapse Role
resource "azurerm_synapse_role_assignment" "synapse_role" {
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  role_name            = "Synapse SQL Administrator"
  principal_id         = var.another_user_object_id

  depends_on = [azurerm_synapse_workspace.synapse, azurerm_synapse_firewall_rule.synapse_firewall, time_sleep.wait_x_seconds]
}


#################################################
# Synapse Components - Linked Service to ADLS
#################################################
# Get Data Lake
data "azurerm_storage_account" "adls" {
  name                = azurerm_storage_account.adls.name
  resource_group_name = azurerm_resource_group.rg.name
}

# Add Linked Service: ADLS
resource "azurerm_synapse_linked_service" "synapse_ls_adls" {
  name                 = "LS_ADLS"
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  type                 = "AzureBlobStorage"
  type_properties_json = <<JSON
  {
    "connectionString": "${data.azurerm_storage_account.adls.primary_connection_string}"
  }
  JSON

  depends_on = [azurerm_synapse_workspace.synapse, azurerm_synapse_role_assignment.synapse_role]
}

# Assign Synapse MSI Access: ADLS
resource "azurerm_role_assignment" "synapse_msi_adls" {
  scope                = data.azurerm_storage_account.adls.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_synapse_workspace.synapse.identity.0.principal_id
}


#################################################
# Synapse Config - Spark Pool
#################################################

# Create Spark Pool
resource "azurerm_synapse_spark_pool" "synapse_spark_pool" {
  name                 = "tfdemosparkpool"
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  node_size_family     = "MemoryOptimized"
  node_size            = "Small"
  cache_size           = 100

  auto_scale {
    max_node_count = 50
    min_node_count = 3
  }

  auto_pause {
    delay_in_minutes = 10
  }

  library_requirement {
    content  = <<EOF
                appnope==0.1.0
                beautifulsoup4==4.6.3
                EOF
    filename = "requirements.txt"
  }

  spark_config {
    content  = <<EOF
                spark.shuffle.spill                true
                EOF
    filename = "config.txt"
  }

  tags = local.tags
}


#################################################
# Synapse Config - Dedicated SQL Pool
#################################################

# resource "azurerm_synapse_sql_pool" "synapse_sql_pool" {
#   name                 = "tfdemosqlpool"
#   synapse_workspace_id = azurerm_synapse_workspace.synapse.id
#   sku_name             = "DW100c"
#   create_mode          = "Default"
# }


#######################################################################################################################
# Output
#######################################################################################################################

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "azure_region" {
  value = azurerm_resource_group.rg.location
}

output "adls_name" {
  value = azurerm_storage_account.adls.name
}

output "synapse_name" {
  value = azurerm_synapse_workspace.synapse.name
}