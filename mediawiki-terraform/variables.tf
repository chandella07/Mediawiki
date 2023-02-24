variable "rg_name" {
  default     = "mediawiki-rg"
  description = "Azure resource group name"
}

variable "rg_location" {
  default     = "eastus"
  description = "Azure resource group name"
}

variable "vm_size" {
  default     = ""
  description = "VM size code"
}

variable "admin_user" {
  default     = ""
  description = "VM admin username"
}

variable "admin_passwd" {
  default     = ""
  description = "VM admin passwd"
}