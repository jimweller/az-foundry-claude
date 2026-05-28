# Deployment

Provisioning and updating Azure AI Foundry resources via OpenTofu.

## Prerequisites

- Azure CLI authenticated (`az login`)
- PIM elevation active for write access to the subscription
- `mise activate` in shell rc (auto-loads env vars from `.mise.toml`)

## Deploy

```bash
cd terraform
tofu init
tofu plan
tofu apply
```

## Add a Model Deployment

1. Add `azapi_resource.<name>` block in `terraform/main.tf` following the existing pattern
2. Add `azapi_resource.<name>.name` to `deployment_names` output in `terraform/outputs.tf`
3. `tofu plan && tofu apply`

Required body structure:

```hcl
body = {
  properties = {
    model = {
      format  = "Anthropic"   # or "DeepSeek"
      name    = "<deployment-name>"
      version = "<version>"
    }
    modelProviderData = {     # Anthropic only
      countryCode      = "US"
      industry         = "healthcare"
      organizationName = var.organization_name
    }
    versionUpgradeOption = "OnceNewDefaultVersionAvailable"
  }
  sku = {
    name     = "GlobalStandard"
    capacity = <tpm>
  }
}
lifecycle {
  ignore_changes = [body, schema_validation_enabled]
}
```

## Recreate a Deployment

`body` block is creation-only due to lifecycle ignore. To force recreation:

```bash
tofu taint azapi_resource.<name>
tofu apply
```

## Region Constraint

Claude models are only available in East US 2 and Sweden Central. `var.location` must be one of these.

## Retrieve API Key

```bash
./scripts/get-api-key.sh
```
