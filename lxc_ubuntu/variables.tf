variable "lxc_containers" {
  type = map(object({
    target_node     = string
    rootfs_storage  = string
    rootfs_size     = string
    ostemplate      = string
  }))
}

variable "pm_api_url" {
  description = "Proxmox API URL"
    type        = string
    default     = null
}

variable "pm_api_token_secret" {
    type        = string
    default     = null
}

variable "pm_api_token_id" {
    type        = string
    default     = null
}

variable "proxmox_api_url" {
  description = "Proxmox API URL"
    type        = string
    default     = null
}

variable "proxmox_api_token_id" {
    type        = string
    default     = null
}

variable "proxmox_api_token_secret" {
    type        = string
    default     = null
}

variable "ssh_public_keys" {
    type        = string
    default     = null
}


variable "minio_access_key" {
    type        = string
    default     = null
}


variable "minio_secret_key" {
    type        = string
    default     = null
}

variable "minio_endpoint" {
    type        = string
    default     = null
}

variable "network_bridge" {
    type        = string
    default     = "eth0"
  }

  variable "network_ip" {
    type        = string
    default     = "dhcp"
    }

    variable "network_gateway" {
        type        = string
        default     = null
       }

    variable "network_subnet" {
        type        = string
        default     = null
       }