provider "azurerm" {
  features {}
}

# ------------------------------
# 1️⃣ Resource Group
# ------------------------------
resource "azurerm_resource_group" "main" {
  name     = "azure-cloud-resume-rg"
  location = "Canada Central"
}

# ------------------------------
# 2️⃣ Storage Account for static files
# ------------------------------
resource "azurerm_storage_account" "static" {
  name                     = "crcstorage${random_id.rand_id.hex}"  # globally unique
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Blob container for static files
resource "azurerm_storage_container" "static" {
  name                  = "static"
  storage_account_name  = azurerm_storage_account.static.name
  container_access_type = "blob"
}

# Random ID for unique names
resource "random_id" "rand_id" {
  byte_length = 4
}

# ------------------------------
# 3️⃣ Cosmos DB Account
# ------------------------------
resource "azurerm_cosmosdb_account" "main" {
  name                = "crccosmos${random_id.rand_id.hex}"
  location            = azurerm_resource_group.main.l