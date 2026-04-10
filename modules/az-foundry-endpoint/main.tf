resource "azurerm_ai_services" "this" {
  name                  = "${var.prefix}-fais"
  location              = var.location
  resource_group_name   = var.resource_group_name
  sku_name              = "S0"
  custom_subdomain_name = "${var.prefix}-fais"
  tags                  = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedOnDate"]]
  }
}

locals {
  default_model_provider_data = {
    countryCode      = "US"
    industry         = "healthcare"
    organizationName = var.organization_name
  }
}

resource "azapi_resource" "opus" {
  type                      = "Microsoft.CognitiveServices/accounts/deployments@2025-10-01-preview"
  name                      = var.models["opus"].name
  parent_id                 = azurerm_ai_services.this.id
  schema_validation_enabled = false

  body = {
    properties = {
      model = {
        format  = var.models["opus"].format
        name    = var.models["opus"].name
        version = var.models["opus"].version
      }
      modelProviderData    = coalesce(var.models["opus"].model_provider_data, local.default_model_provider_data)
      versionUpgradeOption = "OnceNewDefaultVersionAvailable"
    }
    sku = {
      name     = "GlobalStandard"
      capacity = 250
    }
  }

  lifecycle {
    ignore_changes = [body, schema_validation_enabled]
  }
}

resource "azapi_resource" "sonnet" {
  type                      = "Microsoft.CognitiveServices/accounts/deployments@2025-10-01-preview"
  name                      = var.models["sonnet"].name
  parent_id                 = azurerm_ai_services.this.id
  schema_validation_enabled = false

  body = {
    properties = {
      model = {
        format  = var.models["sonnet"].format
        name    = var.models["sonnet"].name
        version = var.models["sonnet"].version
      }
      modelProviderData    = coalesce(var.models["sonnet"].model_provider_data, local.default_model_provider_data)
      versionUpgradeOption = "OnceNewDefaultVersionAvailable"
    }
    sku = {
      name     = "GlobalStandard"
      capacity = 250
    }
  }

  lifecycle {
    ignore_changes = [body, schema_validation_enabled]
  }
}

resource "azapi_resource" "haiku" {
  type                      = "Microsoft.CognitiveServices/accounts/deployments@2025-10-01-preview"
  name                      = var.models["haiku"].name
  parent_id                 = azurerm_ai_services.this.id
  schema_validation_enabled = false

  body = {
    properties = {
      model = {
        format  = var.models["haiku"].format
        name    = var.models["haiku"].name
        version = var.models["haiku"].version
      }
      modelProviderData    = coalesce(var.models["haiku"].model_provider_data, local.default_model_provider_data)
      versionUpgradeOption = "OnceNewDefaultVersionAvailable"
    }
    sku = {
      name     = "GlobalStandard"
      capacity = 250
    }
  }

  lifecycle {
    ignore_changes = [body, schema_validation_enabled]
  }
}
