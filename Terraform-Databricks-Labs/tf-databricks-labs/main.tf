###################################################################################################################################
#### Providers
###################################################################################################################################
# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.31.1"
    }
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.3.2"
    }
  }
}

# Configure the azurerm provider
provider "azurerm" {
    features {}
 }

# Configure the databricks provider
provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.databricks_workspace.id
}

###################################################################################################################################
#### Azure Resource
###################################################################################################################################
# Create Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.azure_region
}

###################################################################################################################################
#### Databricks Workspace & Token
###################################################################################################################################

# Configure AzureRM Databricks Workspace
resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                        = var.databricks_name
  resource_group_name         = var.resource_group_name
  managed_resource_group_name = var.databricks_managed_resource_group_name
  location                    = var.azure_region
  sku                         = var.databricks_sku_name
}

# Create secret_scope
resource "databricks_secret_scope" "secret_scope" {
  name = var.secret_scope_name
  initial_manage_principal = "users"
}

# Create databricks_token
resource "databricks_token" "pat" {
  comment          = "Created from ${abspath(path.module)}"
  lifetime_seconds = 3600
}

# Create databricks_secret
resource "databricks_secret" "token" {
  string_value = databricks_token.pat.token_value
  scope        = databricks_secret_scope.secret_scope.name
  key          = var.databricks_token_name
}

###################################################################################################################################
#### Databricks Cluster & Libraries & Notebook
###################################################################################################################################

# Create databricks_cluster_01
resource "databricks_cluster" "databricks_cluster_01" {
  cluster_name            = var.cluster_name
  spark_version           = var.spark_version
  node_type_id            = var.node_type_id
  autotermination_minutes = var.autotermination_minutes
  autoscale {
    min_workers = var.min_workers
    max_workers = var.max_workers
  }
  
  # Create Libraries
  library {
    pypi {
        package = "pyodbc"
        }
  }
  library {
    maven {
      coordinates = "com.microsoft.azure:spark-mssql-connector_2.12_3.0:1.0.0-alpha"
    }
  }
  custom_tags = {
    Department = "Data Engineering"
  }
}

resource "databricks_notebook" "notebook" {
  content_base64 = base64encode("print('Welcome to Databricks-Labs notebook')")
  path      = var.notebook_path
  language  = "PYTHON"
}

###################################################################################################################################
#### Backend-Config
###################################################################################################################################

# Configure the AzureRM tfstate Name
terraform {
    backend "azurerm" {
        key = "terraform.tfstate"
    }
}

# Import the remote state of the platform level items
data "terraform_remote_state" "platform" {
    backend = "azurerm"
    config = {
        key                  = var.platform_state_key_name
        container_name       = var.platform_state_container_name
        storage_account_name = var.platform_state_storage_account_name
        resource_group_name  = var.platform_state_resource_group_name
    }
}