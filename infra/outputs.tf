###########################################
# Terraform Outputs - Azure Cloud Resume
###########################################

# Resource Group Name
output "resource_group_name" {
  description = "Name of the Azure Resource Group"
  value       = azurerm_resource_group.main.name
}

# Function App Name
output "function_app_name" {
  description = "Name of the Azure Function App"
  value       = azurerm_function_app.visitor.name
}

# Blob Storage Account Name
output "blob_account_name" {
  description = "Name of the Azure Storage Account used for static website hosting"
  value       = azurerm_storage_account.static.name
}

# Cosmos DB Account Name
output "cosmosdb_account_name" {
  description = "Name of the Azure Cosmos DB Account"
  value       = azurerm_cosmosdb_account.main.name
}

###########################################
# Optional: Additional Helpful Outputs
###########################################

# Function App Default URL
output "function_app_url" {
  description = "Default URL endpoint of the deployed Function App"
  value       = "https://${azurerm_function_app.visitor.default_hostname}/"
}

# Storage Account Web Endpoint
output "storage_web_endpoint" {
  description = "Web endpoint of the static website hosted in Azure Blob Storage"
  value       = azurerm_storage_account.static.primary_web_endpoint
}

# Cosmos DB Endpoint
output "cosmosdb_endpoint" {
  description = "Cosmos DB account endpoint URI"
  value       = azurerm_cosmosdb_account.main.endpoint
}
