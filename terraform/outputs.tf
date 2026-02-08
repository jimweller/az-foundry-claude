output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "ai_services_name" {
  value = azurerm_ai_services.this.name
}

output "ai_services_endpoint" {
  value = "https://${azurerm_ai_services.this.custom_subdomain_name}.services.ai.azure.com"
}

output "deployment_names" {
  value = [
    azapi_resource.claude_opus_4_6.name,
    azapi_resource.claude_sonnet_4_5.name,
    azapi_resource.claude_haiku_4_5.name,
    azapi_resource.deepseek_v3_2.name,
  ]
}
