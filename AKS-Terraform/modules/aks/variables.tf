variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}
  
variable "service_principal_name" {
  type = string
}

variable "ssh_public_key" {
  default     = "~/.ssh/host_key.pub"
  description = "SSH public key path"
}

variable "client_id" {
  description = "Service Principal Client ID"
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Service Principal Client Secret"
}