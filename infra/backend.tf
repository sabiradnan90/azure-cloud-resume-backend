terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-backend-rg"       # replace with your RG
    storage_account_name = "terraformbackendstorage"    # replace with your storage account
    container_name       = "tfstate"
    key                  = "cloud-resume.tfstate"
  }
}
