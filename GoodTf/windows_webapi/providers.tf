terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.36.0"
    }
    azapi = {
        source = "Azure/azapi"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}
