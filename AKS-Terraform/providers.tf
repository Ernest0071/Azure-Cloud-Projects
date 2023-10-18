/*
This Terraform code block defines the required provider and its version for the Azure Resource Manager (azurerm) provider. 
It also configures the provider to use default features.
*/

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.71.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.41.0"
    }
  }
}

provider "azurerm" {
  features {}
}