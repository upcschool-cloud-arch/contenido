variable "resource_group_location" {
  type        = string
  description = "Location for all resources."
  default     = "eastus"
}

variable "resource_group_location2" {
  type        = string
  description = "Location for resources in secondary instance."
  default     = "westus"
}

variable "resource_group_name_prefix" {
  type        = string
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
  default     = "rg-sqltest"
}

variable "sql_db_name" {
  type        = string
  description = "The name of the SQL Database."
  default     = "SampleDB"
}

variable "admin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  default     = "azureadmin"
}

variable "admin_password" {
  type        = string
  description = "The administrator password of the SQL logical server."
  sensitive   = true
  default     = null
}

variable "sql_public_ip_allow_start" {
  type = list
  description = "Public IPs allowed to view / access sql instances"
  default = ["8.8.8.8","80.27.234.5"]
}

variable "sql_public_ip_allow_stop" {
  type = list
  description = "Public IPs allowed to view / access sql instances"
  default = ["8.8.8.8","80.27.234.10"]
}

variable "failovergroup_name" {
  type        = string
  description = "failover group name."
  default     = "failovertest29012024"
}