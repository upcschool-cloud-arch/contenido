# Resource group
resource "azurerm_resource_group" "rg" {
	location = var.resource_group_location
	name = var.resource_group_name
}

# Storage account
resource "azurerm_storage_account" "saexample" {
	resource_group_name = var.resource_group_name
	location = var.resource_group_location
	name = var.storage_account_name
	access_tier = "Hot"
  	account_kind = "StorageV2"
  	account_replication_type = "LRS"
  	account_tier = "Standard"
  	allow_nested_items_to_be_public = false
  	enable_https_traffic_only = true
	infrastructure_encryption_enabled = false
	is_hns_enabled = false
  	min_tls_version = "TLS1_2"
  	nfsv3_enabled = false
	cross_tenant_replication_enabled  = false
	public_network_access_enabled = true

	network_rules {
		bypass = var.storage_account_bypass_settings
		default_action = "Deny"
		#default_action = "Allow" # Uncomment this line to allow all traffic
		ip_rules = var.storage_account_public_ip_allow
	}
}