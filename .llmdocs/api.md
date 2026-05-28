# API

Azure AI Foundry Anthropic-compatible messages endpoint.

## Endpoint

```
https://<resource>.services.ai.azure.com/anthropic/v1/messages
```

`<resource>` = `custom_subdomain_name` on `azurerm_ai_services` = `${var.prefix}-fais`

## Authentication

| Header | Value |
| ------ | ----- |
| `x-api-key` | API key from Azure AI Services resource |
| `anthropic-version` | `2023-06-01` |

API key retrieved via `./scripts/get-api-key.sh`.

`custom_subdomain_name` is required on `azurerm_ai_services`; without it the portal shows Entra ID auth only and API key auth is unavailable.

## Claude Code Integration

Settings file `~/.claude/settings-azure.json` passed via `--settings` flag:

| Env Var | Value |
| ------- | ----- |
| `CLAUDE_CODE_USE_FOUNDRY` | `1` |
| `CLAUDE_CODE_USE_BEDROCK` | `0` |
| `ANTHROPIC_FOUNDRY_RESOURCE` | resource name |
| `ANTHROPIC_FOUNDRY_API_KEY` | API key |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | `claude-opus-4-6` |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | `claude-sonnet-4-6` |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | `claude-haiku-4-5` |

## opencode Integration

Model reference format: `az-anthropic/<deployment-name>` or `az-foundry/<deployment-name>`

## Outputs

`terraform/outputs.tf` exposes:
- `resource_group_name`
- `ai_services_name`
- `ai_services_endpoint`
- `deployment_names` — list of all deployed model names
