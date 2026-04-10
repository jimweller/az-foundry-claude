include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  subscription = yamldecode(file(find_in_parent_folders("subscription.yaml")))
  tag_defaults = yamldecode(file(find_in_parent_folders("tag-defaults.yaml")))
}

terraform {
  source = "${get_repo_root()}/modules/subscription-rg"
}

inputs = {
  resource_group_name = "rg-${local.tag_defaults.Project}"
  location            = "eastus2"
  tags = merge(
    local.tag_defaults,
    local.subscription.tags
  )
}
