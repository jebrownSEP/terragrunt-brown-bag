terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.31.0"
    }
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "~> 3.36.0"
    }
    local = {
        source = "hashicorp/local"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azuread" {
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
