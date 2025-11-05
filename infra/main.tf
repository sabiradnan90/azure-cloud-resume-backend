terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ------------------------------
# Random ID for uniqueness
# ------------------------------
resource "random_id" "rand" {
  byte_length = 4
}

# ------------------------------
# 1️⃣ Resource Group
# ------------------------------
resource "azurerm_resource_group" "main" {
  name     = "azure-cloud-resume-rg"
  location = "Canada Central"
}

# ------------------------------
# 2️⃣ Storage Account + Blob container
# ------------------------------
resource "azurerm_storage_account" "static" {
  name                     = "crcstorage${random_id.rand.hex}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "static" {
  name                  = "static"
  storage_account_name  = azurerm_storage_account.static.name
  container_access_type = "blob"
}

# ------------------------------
# 3️⃣ Cosmos DB
# ------------------------------
resource "azurerm_cosmosdb_account" "main" {
  name                = "crccosmos${random_id.rand.hex}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }
}

# ------------------------------
# 4️⃣ Function App Plan
# ------------------------------
resource "azurerm_app_service_plan" "pl_