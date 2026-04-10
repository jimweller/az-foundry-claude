locals {
  managed_by = "terragrunt"
  project    = "az-foundry-claude"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "${get_env("ARM_SUBSCRIPTION_ID")}"
  features {}
}

provider "azapi" {}
EOF
}
