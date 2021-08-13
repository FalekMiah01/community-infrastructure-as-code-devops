###################################################################################################################################
#### Terraform State
###################################################################################################################################

variable "platform_state_key_name" {
    description = "Azure region the resource is located, this is the full region name e.g. West Europe."
}

variable "platform_state_container_name" {
    description = "Azure region the resource is located, this is the full region name e.g. West Europe."
}

variable "platform_state_storage_account_name" {
    description = "Azure region the resource is located, this is the full region name e.g. West Europe."
}

variable "platform_state_resource_group_name" {
    description = "Azure region the resource is located, this is the full region name e.g. West Europe."
}

###################################################################################################################################
#### Azure Resource
###################################################################################################################################

variable "tenant_id" {
  description = "Tenant ID/Directory ID found in Active Directory"
}

variable "subscription_id" {
  description = "The subscription id taken from the environment variable"
}

variable "azure_short_region" {
    description = "Define the short name for the region e.g. weu."
}

variable "azure_region" {
    description = "Azure region the resource is located, this is the full region name e.g. West Europe."
}

variable "resource_group_name" {
  description = "Resource Group Name for Tokenization in Release Pipeline"
}

###################################################################################################################################
#### Databricks
###################################################################################################################################

variable "databricks_name" {
    description = "Default name for Databricks"
}

variable "databricks_managed_resource_group_name" {
    description = "Dabaricks managed resource group name"
}

variable "databricks_sku_name" {
    description = "Databricks tier"
}

variable "secret_scope_name" {
    description = "Secret Scope name for Databricks"
}

variable "databricks_token_name" {
    description = "Token name for Databricks"
}

variable "cluster_name" {
    description = "Default cluster name for Databricks"
}

variable "spark_version" {
  description = "Spark Runtime Version for databricks clusters"
}

variable "node_type_id" {
  description = "Type of worker nodes for databricks clusters"
}

variable "autotermination_minutes" {
    description = "Auto Termination in minutes for databricks clusters"
}

variable "min_workers" {
  description = "Minimum workers in a cluster"
}

variable "max_workers" {
  description = "Maximum workers in a cluster"
}

variable "notebook_path" {
  description = "Path to a notebook"
  default     = "/Shared/Demo/example_notebook"
}