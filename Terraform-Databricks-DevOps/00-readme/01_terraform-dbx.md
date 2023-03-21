# Terraform-Databricks
## Azure Login

Log into the Azure CLI

``` powershell
az login
```

Check Subscriptions available

``` powershell
az account list --output table
``` 

Set Subscription
``` powershell
az account set --subscription="AdvancingAnalytics_6000"
``` 
-------------------------------------------------------------------------------
## 1. Configure the Providers
#### Add Databricks Workspace URL, update: `Host`

``` powershell
## Configure Providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.90.0"
    }
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.4.6"
    }
  }
}

## Configure the azurerm provider
provider "azurerm" {
  features {}
}

# Configure the databricks provider
provider "databricks" {
  host = azurerm_databricks_workspace.databricks_workspace.workspace_url
}
```
-------------------------------------------------------------------------------

## 2. Create Variables & Data Source

#### Create Variables for: `Azure Region`, `Prefix`, `Tags`

``` powershell
variable "azure_region" {
  description = "Azure region the resource is located"
  default     = "UK South"
}

variable "prefix" {
  description = "Prefix for project"
  default     = "databrickslabs"
}

locals {
  tags = {
    Environment = "Dev"
    Owner       = "Falek Miah"
    Env_Prefix  = "dev-${var.prefix}"
  }
}

```
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
## 3. Create Databricks Workspace 

### 3.1 Create Resource Group using Azure provider
  - Update: `Name`, `Location`
  
``` powershell
# Create Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}"
  location = var.azure_region
}
```

### 3.2 Create Databricks workspace using Databricks provider
  - Update: `Name`, `Location`, `Managed Resource Group`, `Tags`

``` powershell
# Create Workspace
resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                        = "${var.prefix}-ws"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = var.azure_region
  sku                         = "standard"
  managed_resource_group_name = "rg-${var.prefix}-managed" # opitional
  tags                        = local.tags
}
```
## 4. Create Databricks Components
*Using Databricks provider*

### 4.1 Create Databricks Cluster, Notebooks and User
  - Update: `Cluster Name`, `User Name`

``` powershell
# Create Cluster
resource "databricks_cluster" "databricks_cluster" {
  cluster_name            = "${var.prefix}-cluster"
  spark_version           = "9.1.x-scala2.12"
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = "10"
  autoscale {
    min_workers = "1"
    max_workers = "4"
  }

  ## Add Libraries
  library {
    pypi {
      package = "pyodbc"
    }
  }

  ## Add Tags
  custom_tags = {
    Department = "dev"
  }
}

#################################################
## Create Notebook
resource "databricks_notebook" "notebook" {
  content_base64 = base64encode("print('Welcome to Databricks-Labs notebook')")
  path           = "/Shared/Demo/demo_example_notebook"
  language       = "PYTHON"
}

#################################################
# Create databricks_user
resource "databricks_user" "my-user" {
  user_name    = "demo-user@databricks.com"
  display_name = "Test Demo User"
}

``` 
-------------------------------------------------------------------------------
## 4. Create Output
  - Create Terraform outputs: `Resource Group`, `Region`, `Databricks Host (URL)`, `Databricks Cluster`

``` powershell
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "azure_region" {
  value = azurerm_resource_group.rg.location
}

output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.databricks_workspace.workspace_url}/"
}

output "databricks_cluster" {
  value = databricks_cluster.databricks_cluster.cluster_name
}
``` 

-------------------------------------------------------------------------------
## 5. Execute Terraform Commands
*Navigate to folder directory before executing commands*

``` powershell

> terraform init

> terraform plan

> terraform apply

> terraform destroy
```
