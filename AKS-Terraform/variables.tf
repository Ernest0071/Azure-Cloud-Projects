variable "rgname" {
  type        = string
  default     = "aks-terraform-dev01"
  description = "Name of the resource group"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "service_principal_name" {
  type = string
}

variable "keyvault_name" {
  type = string
}