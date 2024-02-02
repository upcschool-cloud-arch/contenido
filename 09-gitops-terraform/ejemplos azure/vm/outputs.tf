#variables que mostraremos por pantalla al finalizar el despliegue
#nombre del resource group donde se emplazarán todos los elementos
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

#dirección IP pública que podremos usar para acceder al servidor web
output "public_ip_address" {
  value = azurerm_windows_virtual_machine.main.public_ip_address
}

#contraseña del usuario administrador de la VM por si queremos conectar por RDP
output "admin_password" {
  sensitive = true
  value     = azurerm_windows_virtual_machine.main.admin_password
}
