# Azure Foundry Claude

Secondary Claude Code provider via Azure AI Foundry. For long-running/remote
workloads where AWS Bedrock Okta SSO token expiry is problematic.

## Stack

- OpenTofu >= 1.10
- `azurerm` provider ~> 4.0 (RG, AI Services)
- `azapi` provider ~> 2.0 (model deployments)
- Azure CLI

## Azure Context

- Subscription, resource group, location set in `.envrc`
- PIM elevation required for write access
- Region must support Claude (East US 2 or Sweden Central)

## Deployed Models

| Model             | Deployment Name   | Format    | Deployment Type |
| ----------------- | ----------------- | --------- | --------------- |
| Claude Opus 4.6   | claude-opus-4-6   | Anthropic | Global Standard |
| Claude Sonnet 4.5 | claude-sonnet-4-5 | Anthropic | Global Standard |
| Claude Haiku 4.5  | claude-haiku-4-5  | Anthropic | Global Standard |
| DeepSeek-V3.2     | deepseek-3-2      | DeepSeek  | Global Standard |

## Commands

```bash
PROJECT_ROOT=$(git rev-parse --show-toplevel) && source "$PROJECT_ROOT/.envrc"
cd terraform && tofu init
tofu plan
tofu apply
./scripts/get-api-key.sh
claude --settings ~/.claude/settings-azure.json -p "hello"
```

## IaC Approach

- `azurerm_cognitive_deployment` broken for Anthropic (GitHub #31140)
- `azapi_resource` with `modelProviderData` is the workaround
- `lifecycle { ignore_changes = [body, schema_validation_enabled] }` on all
  deployments — Azure doesn't return `modelProviderData` in GET, parallel PUTs
  cause 409s, provider crashes on PUT response
- `lifecycle { ignore_changes = [tags["CreatedOnDate"]] }` on RG and AI
  Services — Azure policy auto-adds this tag
- Body block is authoritative for creation only; to recreate, `tofu taint` first
- `custom_subdomain_name` on `azurerm_ai_services` required for API key auth;
  without it the portal shows Entra ID auth only
- Claude models only available in East US 2 and Sweden Central

## Endpoint and Auth

- Endpoint: `https://$ANTHROPIC_FOUNDRY_RESOURCE.services.ai.azure.com/anthropic/v1/messages`
- Auth header: `x-api-key`
- Required header: `anthropic-version: 2023-06-01`

## Claude Code Usage

`~/.claude/settings-azure.json` with `--settings` flag:

- `CLAUDE_CODE_USE_FOUNDRY=1`
- `CLAUDE_CODE_USE_BEDROCK=0`
- `ANTHROPIC_FOUNDRY_RESOURCE`
- `ANTHROPIC_FOUNDRY_API_KEY`
- `ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-4-6`
- `ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-4-5`
- `ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4-5`

## One-Shot Testing

```bash
claude --settings ~/.claude/settings-azure.json --model opus -p "hello"
claude --settings ~/.claude/settings-azure.json --model sonnet -p "hello"
claude --settings ~/.claude/settings-azure.json --model haiku -p "hello"
opencode run -m "az-anthropic/claude-opus-4-6" "hello"
opencode run -m "az-anthropic/claude-sonnet-4-5" "hello"
opencode run -m "az-anthropic/claude-haiku-4-5" "hello"
opencode run -m "az-foundry/deepseek-3-2" "hello"
```

## Conventions

- OpenTofu files in `terraform/`
- Shell scripts in `scripts/`
- No secrets in version control
- Conventional commits

## Docs

- `README.md` — architecture, configuration, usage, testing
