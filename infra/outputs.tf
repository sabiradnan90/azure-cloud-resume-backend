output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "function_app_name" {
  value = azurerm_function_app.visitor.name
}

output "blob_account_name" {
  value = azurerm_storage_account.static.name
}

output "cosmosdb_account_name" {
  value = azurerm_cosmosdb_account.main.name
}
