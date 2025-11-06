terraform {
  backend "azurerm" {
    resource_group_name  = "Devops"
    storage_account_name = "myterrfaormstorage"  # updated to match your actual storage account
    container_name       = "tfstate"
    key                  = "cloud-resume.tfstate"
  }
}
