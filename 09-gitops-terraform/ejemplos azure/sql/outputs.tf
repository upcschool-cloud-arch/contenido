#nombre del resource group
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

#nombre de la instancia principal de SQL
output "sql_server_name" {
  value = azurerm_mssql_server.server.name
}

#contraseña del usuario administrador de la instancia de SQL
#se puede mostrar con el comando terraform output admin_password
output "admin_password" {
  sensitive = true
  value     = local.admin_password
}