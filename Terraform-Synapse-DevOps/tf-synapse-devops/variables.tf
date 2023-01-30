#######################################################################################################################
#### Input Variables
#######################################################################################################################
variable "azure_region" {
  description = "Azure region the resource is located"
}

variable "prefix" {
  description = "Prefix for project"
}

variable "another_user_object_id" {
  type        = string
  description = "Another User: Anna"
}

locals {
  tags = {
    Environment = "Dev"
    Owner       = "Falek Miah"
  }
}

#######################################################################################################################
#### Backend Details
#######################################################################################################################

variable "tf_state_backend_resource_group_name" {
    description = "Backend Resource Group"
}

variable "tf_state_backend_storage_account_name" {
    description = "Backend Storage Account"
}

variable "tf_state_backend_container_name" {
    description = "Backend Storage Container"
}

variable "tf_state_backend_key_name" {
    description = "Backend Azure region"
}

#######################################################################################################################
#### Service Connection 
#######################################################################################################################
variable "client_id" {
  description = "Service Principal (SPN) Application (client) ID"
  type = string
}

variable "client_secret" {
  description = "Service Principal (SPN) Application (client) Password"
  type = string
}

variable "tenant_id" {
  description = "Tenant ID/Directory ID"
}

variable "subscription_id" {
  description = "Subscription id"
}