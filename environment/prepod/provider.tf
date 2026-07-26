terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.1.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "terrfaormLearning-rg"
  #   storage_account_name = "terrafomcheckstg"
  #   container_name       = "tfstate"
  #   key                  = "dev.terraform.tfstate"
  # }

}

provider "azurerm" {
  features {}
}
