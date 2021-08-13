output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}

output "name" {
  value = azurerm_databricks_workspace.databricks_workspace.name
}

output "managed_resource_group_name" {
  value = azurerm_databricks_workspace.databricks_workspace.managed_resource_group_name
}

output "sku" {
  value = azurerm_databricks_workspace.databricks_workspace.sku
}