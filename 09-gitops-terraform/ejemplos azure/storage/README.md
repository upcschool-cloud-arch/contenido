<!-- BEGIN_TF_DOCS -->
## Description

Con este código Terraform generaremos los siguientes elementos

* El resource group donde se ubicarán todos los recursos.
* Un storage account que tendrá acceso limitado según la IP de origen.  
  
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.9.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.79.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.saexample](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of the resource group. | `string` | `"westeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | `"rg-storaccounttestaccess"` | no |
| <a name="input_storage_account_bypass_settings"></a> [storage\_account\_bypass\_settings](#input\_storage\_account\_bypass\_settings) | any combination of Logging, Metrics, AzureServices, or None. | `list` | <pre>[<br>  "Metrics",<br>  "Logging",<br>  "AzureServices"<br>]</pre> | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of the resource group | `string` | `"sastoraccount123145"` | no |
| <a name="input_storage_account_public_ip_allow"></a> [storage\_account\_public\_ip\_allow](#input\_storage\_account\_public\_ip\_allow) | Public IPs allowed to view / access storage account contents | `list` | <pre>[<br>  "20.11.0.0/16",<br>  "136.226.214.193"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_storageAccountId"></a> [storageAccountId](#output\_storageAccountId) | n/a |
<!-- END_TF_DOCS -->