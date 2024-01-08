variable "lxc_containers" {
  type = map(object({
    target_node     = string
    rootfs_storage  = string
    rootfs_size     = string
    ostemplate      = string
    ip              = string
    gw              = string
    tag             = string
    password        = string
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

    variable "ip" {
        type        = string
        default     = null
          }

    variable "gw" {
            type = string
          }

    variable "tag" {
            type = string
          }

    variable "cipassword" {
            type = string
          }