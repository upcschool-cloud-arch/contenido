<!-- BEGIN_TF_DOCS -->
## Description

Con este código Terraform generaremos los siguiente elementos: 

* El resource group donde se ubicarán todos los recursos.
* Dos instancias de SQL, la primaria y la secundaria.
* Una base de datos que estará replicada entre las dos instancias. 
* Reglas de firewall para permitir conectar a las instancias desde IP's específicas. 
* Configuración de políticas de backup para modificar las retenciones por defecto. 

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.89.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_mssql_database.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_failover_group.failover](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_failover_group) | resource |
| [azurerm_mssql_firewall_rule.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_firewall_rule.main2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server.server2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_pet.azurerm_mssql_server_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [random_pet.azurerm_mssql_server_name2](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [random_pet.rg_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The administrator password of the SQL logical server. | `string` | `null` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The administrator username of the SQL logical server. | `string` | `"azureadmin"` | no |
| <a name="input_failovergroup_name"></a> [failovergroup\_name](#input\_failovergroup\_name) | failover group name. | `string` | `"failovertest29012024"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location for all resources. | `string` | `"eastus"` | no |
| <a name="input_resource_group_location2"></a> [resource\_group\_location2](#input\_resource\_group\_location2) | Location for resources in secondary instance. | `string` | `"westus"` | no |
| <a name="input_resource_group_name_prefix"></a> [resource\_group\_name\_prefix](#input\_resource\_group\_name\_prefix) | Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription. | `string` | `"rg-sqltest"` | no |
| <a name="input_sql_db_name"></a> [sql\_db\_name](#input\_sql\_db\_name) | The name of the SQL Database. | `string` | `"SampleDB"` | no |
| <a name="input_sql_public_ip_allow_start"></a> [sql\_public\_ip\_allow\_start](#input\_sql\_public\_ip\_allow\_start) | Public IPs allowed to view / access sql instances | `list` | <pre>[<br>  "8.8.8.8",<br>  "80.27.234.5"<br>]</pre> | no |
| <a name="input_sql_public_ip_allow_stop"></a> [sql\_public\_ip\_allow\_stop](#input\_sql\_public\_ip\_allow\_stop) | Public IPs allowed to view / access sql instances | `list` | <pre>[<br>  "8.8.8.8",<br>  "80.27.234.10"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | contraseña del usuario administrador de la instancia de SQL se puede mostrar con el comando terraform output admin\_password |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | nombre del resource group |
| <a name="output_sql_server_name"></a> [sql\_server\_name](#output\_sql\_server\_name) | nombre de la instancia principal de SQL |
<!-- END_TF_DOCS -->