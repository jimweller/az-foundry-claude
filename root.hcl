locals {
  managed_by = "terragrunt"
  project    = "az-foundry-claude"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
  subscription_id = "${get_env("ARM_SUBSCRIPTION_ID")}"
}

provider "azapi" {}
EOF
}
