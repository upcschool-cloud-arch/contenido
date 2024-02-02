output "resource_group_name" {
  value = azurerm_resource_group.rg.name
  description = "The names of the resource group"
}

output "vm_names" {
  value = azurerm_virtual_machine.examplevms.*.name
  description = "The names of the virtual machines"
}

output "vm_hostnames" {
  value = azurerm_virtual_machine.examplevms.*.os_profile
  sensitive = true
  description = "Os information about the virtual machines"
}

output "public_ip_address" {
  value = azurerm_public_ip.examplepip.ip_address
  description = "The public IP address of the Load Balancer"
}

output "admin_password" {
  value = random_password.password.result 
  description = "The admin password of the virtual machines"
  sensitive = true
}