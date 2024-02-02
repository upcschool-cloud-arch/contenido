# Creación de un storage account para almacenar datos de diagnóstico de la VM. 
# El nombre del storage account debe tener entre 3 y 24 caracteres y solo puede usar 
# números y letras minúsculas, por lo que no podemos usar la misma notación que para el resto de recursos 

resource "azurerm_storage_account" "my_storage_account" {
  name                     = "saboots${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
