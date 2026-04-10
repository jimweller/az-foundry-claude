output "ai_services_name" {
  value = azurerm_ai_services.this.name
}

output "endpoint" {
  value = "https://${azurerm_ai_services.this.custom_subdomain_name}.services.ai.azure.com"
}

output "deployment_names" {
  value = [
    azapi_resource.opus.name,
    azapi_resource.sonnet.name,
    azapi_resource.haiku.name,
  ]
}
