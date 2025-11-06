# Random ID for unique names
resource "random_id" "rand" {
  byte_length = 4
}

# 1️⃣ Resource Group
resource "azurerm_resource_group" "main" {
  name     = "azure-cloud-resume-rg-${random_id.rand.hex}"
  location = "Canada Central"
}

# 2️⃣ Storage Account + Container
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

# 3️⃣ Cosmos DB Account
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

# 4️⃣ Function App Plan
resource "azurerm_app_service_plan" "plan" {
  name                = "crc-func-plan-${random_id.rand.hex}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

# 5️⃣ Function App
resource "azurerm_function_app" "visitor" {
  name                       = "crc-visitor-func-${random_id.rand.hex}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  app_service_plan_id        = azurerm_app_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.static.name
  storage_account_access_key = azurerm_storage_account.static.primary_access_key
  version                    = "~4"

  identity {
    type = "SystemAssigned"
  }
}
