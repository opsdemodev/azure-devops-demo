output "resource_group_name" { value = azurerm_resource_group.rg.name }
output "acr_name" { value = azurerm_container_registry.acr.name }
output "acr_login_server" { value = azurerm_container_registry.acr.login_server }
output "container_app_name" { value = azurerm_container_app.app.name }
output "container_app_fqdn" { value = azurerm_container_app.app.latest_revision_fqdn }
output "container_app_url" { value = "https://${azurerm_container_app.app.latest_revision_fqdn}" }
