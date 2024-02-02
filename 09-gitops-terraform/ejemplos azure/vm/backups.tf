#Recurso Vault, donde se almacenan los backups
resource "azurerm_recovery_services_vault" "backupvault" {
  name                = "vault-${var.resources_sufix}"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

#policy de backup que establece la frecuencia del backup y la retencion
resource "azurerm_backup_policy_vm" "bkppolicy" {
  name                = "bkppolicy-${var.resources_sufix}"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backupvault.name

  backup {
    frequency = "Daily"
    time      = var.backup_hour
  }

  retention_daily {
    count = var.backup_retention
  }
}

#asociar la vm a la política de backup
resource "azurerm_backup_protected_vm" "backupvm" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.backupvault.name
  source_vm_id        = azurerm_windows_virtual_machine.main.id
  backup_policy_id    = azurerm_backup_policy_vm.bkppolicy.id
}