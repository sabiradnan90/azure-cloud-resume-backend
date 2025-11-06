terraform {
  backend "azurerm" {
    resource_group_name  = "Devops"
    storage_account_name = "terraformbackendstorage"
    container_name       = "tfstate"
    key                  = "cloud-resume.tfstate"
  }
}
