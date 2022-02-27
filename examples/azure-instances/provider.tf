
terraform {
  required_version = ">= 1.1.0"

  #backend "azurerm" { features {} }
 }

provider "azurerm" {
  features {}
}

