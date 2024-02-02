#Availability set, para minimizar la posibilidad de que un fallo afecte a todas las VMs a la vez
resource "azurerm_availability_set" "avset" {
    name                         = "availset-${var.names_suffix}"
    location                     = var.resource_group_location
    resource_group_name          = azurerm_resource_group.rg.name
    platform_fault_domain_count  = var.numberofnodes
    platform_update_domain_count = 1
    managed                      = true
}


#Máquinas virtuales que conformarán el cluster
resource "azurerm_virtual_machine" "examplevms" {
    count                 = var.numberofnodes
    name                  = "vm-${var.names_suffix}-${count.index}"
    location              = var.resource_group_location
    resource_group_name   = azurerm_resource_group.rg.name
    network_interface_ids  = [azurerm_network_interface.exampleinterface[count.index].id]
    vm_size               = "Standard_D2s_v3"
    delete_os_disk_on_termination = true
    availability_set_id   = azurerm_availability_set.avset.id
    

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
    }

    storage_os_disk {
    name              = "myosdiskC-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

    os_profile {
        computer_name  = "hostname-${count.index}"
        admin_username = var.adminusername
        admin_password = random_password.password.result
    }

    os_profile_windows_config {
        enable_automatic_upgrades = true
        provision_vm_agent        = true
    }

}
#Extensión para lanzar unos comandos que instalan el servidor web IIS y además
#modifican el fichero html por fecto para que muestre el número de servidor que estamos consultando
resource "azurerm_virtual_machine_extension" "web_server_install" {
  count                      = var.numberofnodes
  name                       = "wsi-${var.names_suffix}-${count.index}"
  virtual_machine_id         =  azurerm_virtual_machine.examplevms[count.index].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server  && powershell -ExecutionPolicy Unrestricted -Command \" '<!DOCTYPE html><html><body><h1>Super web cluster</h1><p>Server number ${count.index} here!</p></body></html>' | set-content c:\\inetpub\\wwwroot\\iisstart.htm\" "
    }
  SETTINGS
}