# Azure Foundry Claude

Azure foundry and cognitive services for use with claude code.

## Architecture

| Resource       | Type                   | Name Source               |
| -------------- | ---------------------- | ------------------------- |
| Resource group | azurerm_resource_group | `var.resource_group_name` |
| AI Services    | azurerm_ai_services    | `${var.prefix}-fais`      |
| Claude Opus    | azapi_resource         | `claude-opus-4-6`         |
| Claude Sonnet  | azapi_resource         | `claude-sonnet-4-5`       |
| Claude Haiku   | azapi_resource         | `claude-haiku-4-5`        |
| DeepSeek V3.2  | azapi_resource         | `deepseek-3-2`            |

## Configuration

| Setting         | Value                                                                                               |
| --------------- | --------------------------------------------------------------------------------------------------- |
| Endpoint        | `https://$ANTHROPIC_FOUNDRY_RESOURCE.services.ai.azure.com/anthropic/v1/messages`                   |
| Auth header     | `x-api-key`                                                                                         |
| Required header | `anthropic-version: 2023-06-01`                                                                     |
| Settings file   | `~/.claude/settings-azure.json`                                                                     |
| Env vars        | `ANTHROPIC_FOUNDRY_RESOURCE`, `ANTHROPIC_FOUNDRY_API_KEY` (required by Claude Code in foundry mode) |
| Infra vars      | `ARM_SUBSCRIPTION_ID`, `RESOURCE_GROUP`, `LOCATION` in `.envrc`                                     |

## Usage

```bash
# deploy
PROJECT_ROOT=$(git rev-parse --show-toplevel) && source "$PROJECT_ROOT/.envrc"
cd terraform && tofu init && tofu apply

# retrieve API key
./scripts/get-api-key.sh
```

## Testing

```bash
# curl
curl -X POST "https://$ANTHROPIC_FOUNDRY_RESOURCE.services.ai.azure.com/anthropic/v1/messages" \
  -H "x-api-key: $ANTHROPIC_FOUNDRY_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-opus-4-6","max_tokens":128,"messages":[{"role":"user","content":"hello"}]}'

# claude code
claude --settings ~/.claude/settings-azure.json --model opus -p "hello"
claude --settings ~/.claude/settings-azure.json --model sonnet -p "hello"
claude --settings ~/.claude/settings-azure.json --model haiku -p "hello"

# opencode
opencode run -m "az-anthropic/claude-opus-4-6" "hello"
opencode run -m "az-anthropic/claude-sonnet-4-5" "hello"
opencode run -m "az-anthropic/claude-haiku-4-5" "hello"
opencode run -m "az-foundry/deepseek-3-2" "hello"
```
