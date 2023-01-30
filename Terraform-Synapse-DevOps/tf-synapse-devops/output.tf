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