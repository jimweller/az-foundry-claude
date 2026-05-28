# Ops

Maintenance and operational runbooks for az-foundry-claude.

## Test Connectivity

```bash
# Claude Code
claude --settings ~/.claude/settings-azure.json --model opus -p "hello"
claude --settings ~/.claude/settings-azure.json --model sonnet -p "hello"
claude --settings ~/.claude/settings-azure.json --model haiku -p "hello"

# opencode
opencode run -m "az-anthropic/claude-opus-4-8" "hello"
opencode run -m "az-anthropic/claude-opus-4-6" "hello"
opencode run -m "az-anthropic/claude-sonnet-4-6" "hello"
opencode run -m "az-anthropic/claude-haiku-4-5" "hello"
opencode run -m "az-foundry/deepseek-3-2" "hello"
```

## Rotate API Key

1. Azure portal -> AI Services resource -> Keys and Endpoint
2. Regenerate key
3. Update `ANTHROPIC_FOUNDRY_API_KEY` in `~/.claude/settings-azure.json`

## Check Deployment Status

```bash
az cognitiveservices account deployment list \
  --resource-group <rg> \
  --name <ai-services-name>
```

## PIM Elevation

Required for all write operations (apply, taint, destroy). Elevate via Azure portal or:

```bash
az role assignment create ...  # per org PIM process
```

## Drift Detection

Due to `ignore_changes = [body]`, `tofu plan` will always show no changes for deployment bodies. Drift in model configuration is not detectable without taint + plan.

## State Files

`terraform/terraform.tfstate` and backups are local (no remote backend). Do not commit state files.
