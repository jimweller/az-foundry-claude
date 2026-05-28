# Architecture

OpenTofu IaC provisioning Azure AI Foundry resources for Claude Code model access.

## Components

| Component | Resource | File |
| --------- | -------- | ---- |
| Resource Group | `azurerm_resource_group.this` | `terraform/main.tf:3` |
| AI Services account | `azurerm_ai_services.this` | `terraform/main.tf:13` |
| Model deployments | `azapi_resource.*` | `terraform/main.tf:26+` |

## Data Flow

```
Claude Code / opencode client
  -> HTTPS -> Azure AI Foundry endpoint
  -> AI Services account (custom subdomain)
  -> Model deployment (azapi_resource)
  -> Anthropic / DeepSeek provider
```

## Provider Strategy

- `azurerm` manages RG and AI Services account
- `azapi` manages all model deployments via `Microsoft.CognitiveServices/accounts/deployments@2025-10-01-preview`
- `azurerm_cognitive_deployment` is broken for Anthropic (GitHub #31140); `azapi_resource` with `modelProviderData` is the workaround

## Lifecycle Constraints

- All `azapi_resource` deployments: `ignore_changes = [body, schema_validation_enabled]`
  - Azure does not return `modelProviderData` in GET responses
  - Parallel PUTs cause HTTP 409 conflicts
  - Provider crashes on PUT response
- RG and AI Services: `ignore_changes = [tags["CreatedOnDate"]]` — Azure policy auto-adds this tag
- `body` block is authoritative for creation only; use `tofu taint` to recreate a deployment

## Directory Layout

```
terraform/    # All IaC — providers, variables, main, outputs
scripts/      # Helper shell scripts and utilities
```
