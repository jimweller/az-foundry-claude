# Data Model

Azure resource hierarchy and Terraform variable schema.

## Resource Hierarchy

```
Azure Subscription
  azurerm_resource_group.this
    azurerm_ai_services.this  (S0 SKU, custom subdomain)
      azapi_resource.claude_opus_4_8
      azapi_resource.claude_opus_4_7
      azapi_resource.claude_opus_4_6
      azapi_resource.claude_sonnet_4_6
      azapi_resource.claude_sonnet_4_5
      azapi_resource.claude_haiku_4_5
      azapi_resource.deepseek_v3_2
```

## Model Deployments

| Terraform Resource | Deployment Name | Format | Model Version | Capacity (TPM) |
| ------------------ | --------------- | ------ | ------------- | -------------- |
| `claude_opus_4_8` | `claude-opus-4-8` | Anthropic | 1 | 2000 |
| `claude_opus_4_7` | `claude-opus-4-7` | Anthropic | 1 | 2000 |
| `claude_opus_4_6` | `claude-opus-4-6` | Anthropic | 1 | 2000 |
| `claude_sonnet_4_6` | `claude-sonnet-4-6` | Anthropic | 1 | 4000 |
| `claude_sonnet_4_5` | `claude-sonnet-4-5` | Anthropic | 20250929 | 4000 |
| `claude_haiku_4_5` | `claude-haiku-4-5` | Anthropic | 20251001 | 4000 |
| `deepseek_v3_2` | `deepseek-3-2` | DeepSeek | 1 | 10000 |

All deployments: SKU `GlobalStandard`, `versionUpgradeOption: OnceNewDefaultVersionAvailable`.

Anthropic deployments include `modelProviderData`: `countryCode=US`, `industry=healthcare`, `organizationName=var.organization_name`.

## Variables (`terraform/variables.tf`)

| Variable | Type | Purpose |
| -------- | ---- | ------- |
| `subscription_id` | string | Azure subscription |
| `resource_group_name` | string | RG name |
| `location` | string | Azure region (East US 2 or Sweden Central) |
| `prefix` | string | Name prefix for resources |
| `organization_name` | string | Anthropic modelProviderData org field |
| `tags` | map(string) | Resource tags |

Variable values sourced from `.mise.toml` env vars, auto-loaded on `cd`.
