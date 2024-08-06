variable "vms" {
  description = "Map of virtual machine configurations"
  type = map(object({
    name        = string
    cpu_cores   = number
    memory_mb   = number
    ip_address  = string
    disk_size   = number
  }))
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "default_gateway" {
  description = "The default gateway for IP configuration"
  type        = string
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

