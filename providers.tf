terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    namecheap = {
      source = "namecheap/namecheap"
      version = ">= 2.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}
/*
# Namecheap API credentials
provider "namecheap" {
  client_ip = ""
  use_sandbox = false
}
*/