variable "lxc_containers" {
  type = map(object({
    target_node     = optional(string, "nerd-pve04")
    rootfs_storage  = optional(string, "pve-iscsi-lun0")
    rootfs_size     = optional(string, "10G")
    ostemplate      = optional(string, "ISO:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst")
    ip              = string
    gw              = optional(string, "10.0.40.1")
    tag             = optional(string, "40")
    start           = optional(bool, true)
    onboot          = optional(bool, true)
    cores           = optional(string, "1")
    memory          = optional(string, "512")
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

variable "minio_secret_key" {
    type        = string
    default     = null
}

variable "minio_endpoint" {
    type        = string
    default     = null
}

variable "cipassword" {
    type        = string
    default     = null
}

variable "cores" {
    type        = string
    default     = null
}
