# Output for the name of the resource group created
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

# Output for the client ID of the AzureAD application created
output "client_id" {
  description = "The application id of AzureAD application created."
  value       = module.ServicePrincipal.client_id
}

# Output for the client secret of the AzureAD application created
output "client_secret" {
  description = "Password for service principal."
  value       = module.ServicePrincipal.client_secret
  sensitive   = true
}