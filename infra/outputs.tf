output "resource_group_name" { value = azurerm_resource_group.rg.name }
output "function_app_name" { value = azurerm_function_app.func.name }
output "function_default_hostname" { value = azurerm_function_app.func.default_hostname }
output "blob_static_url" { value = "https://${azurerm_storage_account.blob_sa.name}.blob.core.windows.net/${azurerm_storage_container.static_files.name}/" }
