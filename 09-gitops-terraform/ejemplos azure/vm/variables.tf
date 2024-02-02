variable "resources_sufix" {
  default     = "vruiz-test"
  description = "Sufix that will be used for all the resources"
}

variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "vnet_address_space" {
  default     = ["10.0.0.0/16"]
  description = "Address range of the VNET"
}

variable "subnet_address_range" {
  default     = ["10.0.1.0/24"]
  description = "Address range of the subnet"
}

variable "vm_size" {
  default     = "Standard_DS1_v2"
  description = "Size of the VM"
}

variable "vm_disk_type" {
  default     = "Premium_LRS"
  description = "Type of the VM disk"
}

variable "backup_retention" {
  default     = 10
  description = "Number of days to retain the backups"
}

variable "backup_hour" {
  default     = "23:00"
  description = "Time where the daily backup will be executed"
}

variable "admin_username" {
  default     = "azureuser"
  description = "Admin username for the VM"
}