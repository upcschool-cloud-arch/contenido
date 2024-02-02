<!-- BEGIN_TF_DOCS -->
## Description

Con este código Terraform generaremos los siguientes elementos

* El resource group donde se ubicarán todos los recursos.
* La VNET y la subred donde estará ubicada la máquina virtual.
* Una IP pública a través de la cual podremos acceder a la máquina virtual.
* Un Network Security Group con las reglas necesarias para permitir el acceso a la máquina.
* Una interfaz de red que conectaremos a la máquina virtual para que tenga conectividad.
* Una máquina virtual Windows con el servidor web IIS instalado.
* Un storage account en el que se almacenarán algunos logs del registro de arranque de la máquina virtual.
* Un Backup Vault en el que se almacenarán las copias de seguridad de la máquina virtual.
* Una planificación de copias de seguridad para la máquina virtual, de manera que se realizará de manera diaria una copia de ésta. 
  
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.84.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_backup_policy_vm.bkppolicy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm) | resource |
| [azurerm_backup_protected_vm.backupvm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_vm) | resource |
| [azurerm_network_interface.my_terraform_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.my_terraform_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.my_terraform_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_recovery_services_vault.backupvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/recovery_services_vault) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.my_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_subnet.my_terraform_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_machine_extension.web_server_install](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_network.my_terraform_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_windows_virtual_machine.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_id.random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Admin username for the VM | `string` | `"azureuser"` | no |
| <a name="input_backup_hour"></a> [backup\_hour](#input\_backup\_hour) | Time where the daily backup will be executed | `string` | `"23:00"` | no |
| <a name="input_backup_retention"></a> [backup\_retention](#input\_backup\_retention) | Number of days to retain the backups | `number` | `10` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of the resource group. | `string` | `"eastus"` | no |
| <a name="input_resources_sufix"></a> [resources\_sufix](#input\_resources\_sufix) | Sufix that will be used for all the resources | `string` | `"vruiz-test"` | no |
| <a name="input_subnet_address_range"></a> [subnet\_address\_range](#input\_subnet\_address\_range) | Address range of the subnet | `list` | <pre>[<br>  "10.0.1.0/24"<br>]</pre> | no |
| <a name="input_vm_disk_type"></a> [vm\_disk\_type](#input\_vm\_disk\_type) | Type of the VM disk | `string` | `"Premium_LRS"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Size of the VM | `string` | `"Standard_DS1_v2"` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | Address range of the VNET | `list` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | contraseña del usuario administrador de la VM por si queremos conectar por RDP |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | dirección IP pública que podremos usar para acceder al servidor web |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | variables que mostraremos por pantalla al finalizar el despliegue nombre del resource group donde se emplazarán todos los elementos |
<!-- END_TF_DOCS -->