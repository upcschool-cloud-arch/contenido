#recursos genéricos, como el resource group y funciones auxiliares
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "rg-${var.resources_sufix}"
}
#para generar contraseñas aleatorias
resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

# Generación de un nombre aleatorio para el storage account
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }
  byte_length = 8
}