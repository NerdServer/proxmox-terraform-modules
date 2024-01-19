variable "ssh_password" {
  type        = string
}

variable "ssh_user" {
  type        = string
}

variable "ssh_pub_keys" {
  type        = string
}

variable "vms" {
  type        = map(any)
}



variable "ciuser" {
  type = string
  
}

variable "cipassword" {
  type = string
  
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
}

variable "source_template" {
  type = string
}