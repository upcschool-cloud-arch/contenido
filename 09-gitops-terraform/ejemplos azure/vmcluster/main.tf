#Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.names_suffix}"
  location = var.resource_group_location
}

#contraseña aleatoria para el usuario administrador de las máquinas virtuales
resource "random_password" "password" {
  length  = 16
  special = true
  lower   = true
  upper   = true
  numeric = true
}