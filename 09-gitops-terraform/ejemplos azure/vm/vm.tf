# Creación de la máquina virtual
resource "azurerm_windows_virtual_machine" "main" {
  name                  = "vm-${var.resources_sufix}"
  
  admin_username        = var.admin_username
  admin_password        = random_password.password.result
  
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  #observar que el atributo network_interface_ids es un array, por lo que se puede agregar más de una interfaz de red
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = var.vm_size

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = var.vm_disk_type
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  #configuración de un storage account en el que guardar datos de diagnóstico del arranque (output de consola, screenshots...)
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}

# Instalación del rol de servidor web en la máquina virtual
resource "azurerm_virtual_machine_extension" "web_server_install" {
  name                       = "wsi-${var.resources_sufix}"
  virtual_machine_id         = azurerm_windows_virtual_machine.main.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server"
    }
  SETTINGS
}
