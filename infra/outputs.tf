output "resource_group_name" {
  description = "Name of the Azure Resource Group"
  value       = azurerm_resource_group.main.name
}

output "function_app_name" {
  description = "Name of the Azure Function App"
  value       = azurerm_function_app.visitor.name
}

output "blob_account_name" {
  description = "Name of the Azure Storage Account"
  value       = azurerm_storage_account.static.name
}

output "cosmosdb_account_name" {
  description = "Name of the Azure Cosmos DB Account"
  value       = azurerm_cosmosdb_account.main.name
}

output "function_app_url" {
  description = "Function App default URL"
  value       = "https://${azurerm_function_app.visitor.default_hostname}/"
}

output "storage_web_endpoint" {
  description = "Static website endpoint"
  value       = azurerm_storage_account.static.primary_web_endpoint
}

output "cosmosdb_endpoint" {
  description = "Cosmos DB endpoint"
  value       = azurerm_cosmosdb_account.main.endpoint
}
