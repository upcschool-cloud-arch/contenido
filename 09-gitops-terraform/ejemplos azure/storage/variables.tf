variable "resource_group_location" {
  type        = string
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "rg-storaccounttestaccess"
  description = "Name of the resource group"
}

variable "storage_account_name" {
  type        = string
  default     = "sastoraccount123145"
  description = "Name of the resource group"
}

variable "storage_account_bypass_settings" {
  type = list
  description = "any combination of Logging, Metrics, AzureServices, or None."
  default = ["Metrics", "Logging", "AzureServices"]
}

variable "storage_account_public_ip_allow" {
  type = list
  description = "Public IPs allowed to view / access storage account contents"
  default = ["20.11.0.0/16","136.226.214.193"]
}

