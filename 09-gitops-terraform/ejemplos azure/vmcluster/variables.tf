variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location for all resources."
}

variable "names_suffix" {
  type        = string
  default     = "test-vmcluster"
  description = "Prefix of the resource group name that's combined with a random value so name is unique in your Azure subscription."
}

variable "numberofnodes" {
  type        =  number
  description = "Number of nodes in the cluster."
  default     = 3
}

variable "adminusername" {
  type        = string
  description = "Admin username for the VMs."
  default     = "testadmin"
}

variable "subnet_ranges" {
  type        = list(string)
  description = "Ranges of the subnets in the virtual network."
  default     = ["10.0.1.0/24"]
}

variable "vm_names" {
  type        = string
  default     = "test"
  description = "Prefix of the resource group name that's combined with a random value so name is unique in your Azure subscription."
}

variable "subnet_names" {
  type        = list(string)
  default     = ["subnet-test-1"]
  description = "Names of the subnets in the virtual network."
}