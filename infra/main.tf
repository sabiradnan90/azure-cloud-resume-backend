locals { name_prefix = var.prefix }

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}-rg"
  location = var.location
}

# Blob Storage
resource "azurerm_storage_account" "blob_sa" {
  name                     = var.blob_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
  kind                     = "StorageV2"
}

resource "azurerm_storage_container" "static_files" {
  name                  = "static"
  storage_account_name  = azurerm_storage_account.blob_sa.name
  container_access_type = "blob"
}

# Cosmos DB
resource "azurerm_cosmosdb_account" "cosmos" {
  name                = var.cosmosdb_account_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  enable_automatic_failover = false
  consistency_policy { consistency_level = "Session" }
  geo_location { location = azurerm_resource_group.rg.location; failover_priority = 0 }
}

resource "azurerm_cosmosdb_sql_database" "db" {
  name                = "visitorDB"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
}

resource "azurerm_cosmosdb_sql_container" "counter" {
  name                = "VisitorCounter"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.db.name
  partition_key_path  = "/id"
  throughput          = 400
}

# App Service Plan
resource "azurerm_app_service_plan" "plan" {
  name                = "${local.name_prefix}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  sku { tier = "Dynamic"; size = "Y1" }
}

# Application Insights
resource "azurerm_application_insights" "appi" {
  name                = "${local.name_prefix}-appi"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

# Function App
resource "azurerm_function_app" "func" {
  name                       = "${local.name_prefix}-visitor-func"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.blob_sa.name
  storage_account_access_key = azurerm_storage_account.blob_sa.primary_access_key
  version                    = "~4"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME        = var.function_runtime
    WEBSITE_RUN_FROM_PACKAGE        = "1"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.appi.instrumentation_key
    COSMOS_DB_ACCOUNT               = azurerm_cosmosdb_account.cosmos.name
    COSMOS_DB_DATABASE              = azurerm_cosmosdb_sql_database.db.name
    COSMOS_DB_CONTAINER             = azurerm_cosmosdb_sql_container.counter.name
  }

  identity { type = "SystemAssigned" }
}

# Role assignment for managed identity
resource "azurerm_role_assignment" "func_cosmos_access" {
  principal_id         = azurerm_function_app.func.identity.principal_id
  role_definition_name = "Cosmos DB Built-in Data Contributor"
  scope                = azurerm_cosmosdb_account.cosmos.id
}
