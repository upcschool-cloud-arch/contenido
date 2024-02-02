<!-- BEGIN_TF_DOCS -->
## Description

Con este código Terraform generaremos los siguiente elementos: 

* El resource group donde se ubicarán todos los recursos.
* La VNET y la subnet donde estarán ubicadas las máquinas virtuales.
* Una IP pública a través de la que se accederá al servicio.
* Un balanceador que repartirá las peticiones entre todas las máquinas disponibles. 
* Una sonda que detecta si el balanceador puede realizar peticiones a las máquinas.
* Un Network Security Group para permitir el tráfico deseado (en este caso HTTP).
* Un conjunto de máquinas virtuales que serán las que responderán a las peticiones del balanceador.
* Un grupo de disponibilidad para minimizar la probabilidad de que todas las VMs fallen al mismo tiempo.
* Configuración automática para instalar el servidor web en las máquinas virtuales y modificar la página de inicio. 

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.88.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network"></a> [network](#module\_network) | Azure/network/azurerm | 5.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_availability_set.avset](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |
| [azurerm_lb.examplelb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.examplebackendaddpool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_probe.exampleprobe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.examplelbrule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_network_interface.exampleinterface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_backend_address_pool_association.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_security_group_association.nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.vms_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.examplepip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_virtual_machine.examplevms](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine) | resource |
| [azurerm_virtual_machine_extension.web_server_install](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_adminusername"></a> [adminusername](#input\_adminusername) | Admin username for the VMs. | `string` | `"testadmin"` | no |
| <a name="input_names_suffix"></a> [names\_suffix](#input\_names\_suffix) | Prefix of the resource group name that's combined with a random value so name is unique in your Azure subscription. | `string` | `"test-vmcluster"` | no |
| <a name="input_numberofnodes"></a> [numberofnodes](#input\_numberofnodes) | Number of nodes in the cluster. | `number` | `3` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location for all resources. | `string` | `"eastus"` | no |
| <a name="input_subnet_names"></a> [subnet\_names](#input\_subnet\_names) | Names of the subnets in the virtual network. | `list(string)` | <pre>[<br>  "subnet-test-1"<br>]</pre> | no |
| <a name="input_subnet_ranges"></a> [subnet\_ranges](#input\_subnet\_ranges) | Ranges of the subnets in the virtual network. | `list(string)` | <pre>[<br>  "10.0.1.0/24"<br>]</pre> | no |
| <a name="input_vm_names"></a> [vm\_names](#input\_vm\_names) | Prefix of the resource group name that's combined with a random value so name is unique in your Azure subscription. | `string` | `"test"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | The admin password of the virtual machines |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | The public IP address of the Load Balancer |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The names of the resource group |
| <a name="output_vm_hostnames"></a> [vm\_hostnames](#output\_vm\_hostnames) | Os information about the virtual machines |
| <a name="output_vm_names"></a> [vm\_names](#output\_vm\_names) | The names of the virtual machines |
<!-- END_TF_DOCS -->