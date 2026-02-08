data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedOnDate"]]
  }
}

resource "azurerm_ai_services" "this" {
  name                  = "${var.prefix}-fais"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  sku_name              = "S0"
  custom_subdomain_name = "${var.prefix}-fais"
  tags                  = var.tags

  lifecycle {
    ignore_changes = [tags["CreatedOnDate"]]
  }
}

resource "azapi_resource" "claude_opus_4_6" {
  type                      = "Microsoft.CognitiveServices/accounts/deployments@2025-10-01-preview"
  name                      = "claude-opus-4-6"
  parent_id                 = azurerm_ai_services.this.id
  schema_validation_enabled = false

  body = {
    properties = {
      model = {
        format  = "Anthropic"
        name    = "claude-opus-4-6"
        version = "1"
      }
      modelProviderData = {
        countryCode      = "US"
        industry         = "healthcare"
        organizationName = var.organization_name
      }
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

resource "azapi_resource" "claude_sonnet_4_5" {
  type                      = "Microsoft.CognitiveServices/accounts/deployments@2025-10-01-preview"
  name                      = "claude-sonnet-4-5"
  parent_id                 = azurerm_ai_services.this.id
  schema_validation_enabled = false

  body = {
    properties = {
      model = {
        format  = "Anthropic"
        name    = "claude-sonnet-4-5"
        version = "20250929"
      }
      modelProviderData = {
        countryCode      = "US"
        industry         = "healthcare"
        organizationName = var.organization_name
      }
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

resource "azapi_resource" "claude_haiku_4_5" {
  type                      = "Microsoft.CognitiveServices/accounts/deployments@2025-10-01-preview"
  name                      = "claude-haiku-4-5"
  parent_id                 = azurerm_ai_services.this.id
  schema_validation_enabled = false

  body = {
    properties = {
      model = {
        format  = "Anthropic"
        name    = "claude-haiku-4-5"
        version = "20251001"
      }
      modelProviderData = {
        countryCode      = "US"
        industry         = "healthcare"
        organizationName = var.organization_name
      }
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

resource "azapi_resource" "deepseek_v3_2" {
  type                      = "Microsoft.CognitiveServices/accounts/deployments@2025-10-01-preview"
  name                      = "deepseek-3-2"
  parent_id                 = azurerm_ai_services.this.id
  schema_validation_enabled = false

  body = {
    properties = {
      model = {
        format  = "DeepSeek"
        name    = "DeepSeek-V3.2"
        version = "1"
      }
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
