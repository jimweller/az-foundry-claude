#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="${RESOURCE_GROUP:?Set RESOURCE_GROUP}"
AIS_NAME="${AIS_NAME:?Set AIS_NAME}"

az cognitiveservices account keys list \
  --name "$AIS_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query key1 -o tsv
